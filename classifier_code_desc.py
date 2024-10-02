import ast
import json
import os
import random
from typing import List, Tuple

import numpy as np
import pandas as pd
import torch
import torch.nn as nn
import torch.optim as optim
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score, precision_score, recall_score
from sklearn.model_selection import KFold, train_test_split
from torch.optim.lr_scheduler import CosineAnnealingLR, ReduceLROnPlateau
from torch.utils.data import DataLoader, TensorDataset

class CombinedEmbeddingDataset:
    def __init__(self, desc_file: str, code_file: str):
        self.desc_data = pd.read_csv(desc_file)
        self.code_data = pd.read_csv(code_file)
        self.desc_embeddings = [ast.literal_eval(emb)[0] for emb in self.desc_data['embeddings']]
        self.code_embeddings = [ast.literal_eval(emb)[0] for emb in self.code_data['embeddings']]
        self.labels = self.desc_data['label'].values

class MLB(nn.Module):
    """Multimodal Low-rank Bilinear Pooling module."""
    def __init__(self, desc_dim, code_dim, output_dim):
        super(MLB, self).__init__()
        self.desc_projector = nn.Linear(desc_dim, output_dim)
        self.code_projector = nn.Linear(code_dim, output_dim)
        
    def forward(self, desc, code):
        desc_projected = self.desc_projector(desc)
        code_projected = self.code_projector(code)
        return torch.mul(desc_projected, code_projected)

class CombinedEmbeddingClassifier(nn.Module):
    """Classifier using MLB fusion for combining description and code embeddings."""
    def __init__(self, desc_input_dim=768, code_input_dim=768):
        super(CombinedEmbeddingClassifier, self).__init__()
        
        # MLB fusion layer
        self.mlb_fusion = MLB(desc_input_dim, code_input_dim, 512)
        
        # Classifier layers
        self.classifier = nn.Sequential(
            nn.Linear(512, 256),
            nn.BatchNorm1d(256),
            nn.ReLU(),
            nn.Dropout(0.3),
            
            nn.Linear(256, 128),
            nn.BatchNorm1d(128),
            nn.ReLU(),
            nn.Dropout(0.3),
            
            nn.Linear(128, 1)
        )

    def forward(self, desc_x, code_x):
        fused_features = self.mlb_fusion(desc_x, code_x)
        return self.classifier(fused_features)

def set_random_seed(seed: int = 6742):
    """Set random seed for reproducibility."""
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.backends.cudnn.deterministic = True

def k_fold_cross_validation(desc_features, code_features, labels, k=5):
    kf = KFold(n_splits=k, shuffle=True, random_state=42)
    
    all_metrics = {
        'accuracies': [], 'precisions': [], 'recalls': [], 'f1_scores': [], 'confusion_matrices': []
    }

    for fold, (train_index, val_index) in enumerate(kf.split(desc_features), 1):
        # print(f"Fold {fold}/{k}")
        
        desc_x_train, desc_x_val = desc_features[train_index], desc_features[val_index]
        code_x_train, code_x_val = code_features[train_index], code_features[val_index]
        y_train, y_val = labels[train_index], labels[val_index]
        
        desc_x_train, code_x_train, y_train = augment_minority_class(desc_x_train, code_x_train, y_train)
        
        train_dataset = TensorDataset(torch.tensor(desc_x_train).float(), torch.tensor(code_x_train).float(), torch.tensor(y_train).float())
        val_dataset = TensorDataset(torch.tensor(desc_x_val).float(), torch.tensor(code_x_val).float(), torch.tensor(y_val).float())
        train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
        val_loader = DataLoader(val_dataset, batch_size=32, shuffle=False)

        model = CombinedEmbeddingClassifier()
        optimizer = optim.Adam(model.parameters(), lr=0.001)
        criterion = nn.BCEWithLogitsLoss()
        scheduler = CosineAnnealingLR(optimizer, T_max=50)

        train_model(model, train_loader, criterion, optimizer, scheduler, epochs=50)

        y_true, y_pred = evaluate_model(model, val_loader)
        
        accuracy, precision, recall, f1, conf_matrix = calculate_metrics(y_true, y_pred)
        
        for key, value in zip(all_metrics.keys(), [accuracy, precision, recall, f1, conf_matrix]):
            all_metrics[key].append(value)

    # Calculate and print average metrics
    for key in ['accuracies', 'precisions', 'recalls', 'f1_scores']:
        mean_value = np.mean(all_metrics[key])
        std_value = np.std(all_metrics[key])
        print(f'Mean {key[:-3].capitalize()}: {mean_value:.2f} ± {std_value:.2f}')

    print('Total Confusion Matrix:')
    print(np.sum(all_metrics['confusion_matrices'], axis=0))

    return all_metrics

def augment_minority_class(desc_features: np.ndarray, code_features: np.ndarray, labels: np.ndarray) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Augment minority class samples to balance the dataset."""
    positive_indices = np.where(labels == 1)[0]
    negative_indices = np.where(labels == 0)[0]
    
    num_positives = len(positive_indices)
    num_negatives = len(negative_indices)
    
    num_copies = num_negatives // num_positives - 1
    
    augmented_desc_features = np.concatenate([desc_features] + [desc_features[positive_indices]] * num_copies)
    augmented_code_features = np.concatenate([code_features] + [code_features[positive_indices]] * num_copies)
    augmented_labels = np.concatenate([labels] + [labels[positive_indices]] * num_copies)
    
    shuffle_indices = np.random.permutation(len(augmented_labels))
    return augmented_desc_features[shuffle_indices], augmented_code_features[shuffle_indices], augmented_labels[shuffle_indices]

def load_and_preprocess_data(desc_file_paths: List[str], code_file_paths: List[str]) -> Tuple[pd.DataFrame, pd.DataFrame]:
    """Load and preprocess data from multiple CSV files for both desc and code."""
    desc_dataframes = [pd.read_csv(file) for file in desc_file_paths]
    code_dataframes = [pd.read_csv(file) for file in code_file_paths]
    
    combined_desc_data = pd.concat(desc_dataframes, ignore_index=True)
    combined_code_data = pd.concat(code_dataframes, ignore_index=True)
    
    combined_desc_data['embeddings'] = combined_desc_data['embeddings'].apply(lambda x: [ast.literal_eval(x)])
    combined_code_data['embeddings'] = combined_code_data['embeddings'].apply(lambda x: [ast.literal_eval(x)])
    
    return combined_desc_data, combined_code_data

def train_model(model, train_loader, criterion, optimizer, scheduler, epochs):
    for epoch in range(epochs):
        model.train()
        total_loss = 0
        for desc_inputs, code_inputs, targets in train_loader:
            if desc_inputs.size(0) == 1:
                continue  # Skip batch size of 1
            optimizer.zero_grad()
            outputs = model(desc_inputs, code_inputs)
            loss = criterion(outputs, targets.float())
            loss.backward()
            optimizer.step()
            total_loss += loss.item()
        
        avg_loss = total_loss / len(train_loader)
        scheduler.step()
        
        current_lr = scheduler.get_last_lr()[0]
        # print(f"Epoch {epoch+1}/{epochs}, Loss: {avg_loss:.4f}, LR: {current_lr:.6f}")

def evaluate_model(model: nn.Module, test_loader: DataLoader) -> Tuple[List, List]:
    """Evaluate the model and return true labels and predictions."""
    model.eval()
    y_true, y_pred = [], []
    with torch.no_grad():
        for desc_inputs, code_inputs, targets in test_loader:
            outputs = model(desc_inputs, code_inputs)
            outputs = torch.sigmoid(outputs)
            
            predicted = (outputs > 0.7).float()
            
            y_true.extend(targets.cpu().numpy())
            y_pred.extend(predicted.cpu().numpy())
    return y_true, y_pred

def calculate_metrics(y_true: List, y_pred: List) -> Tuple[float, float, float, float, np.ndarray]:
    """Calculate performance metrics."""
    return (
        accuracy_score(y_true, y_pred),
        precision_score(y_true, y_pred),
        recall_score(y_true, y_pred),
        f1_score(y_true, y_pred),
        confusion_matrix(y_true, y_pred)
    )

def do_train_and_evaluate_MLP(desc_file_path_0: str, desc_file_path_1: str, code_file_path_0: str, code_file_path_1: str, vul_type: str):
    set_random_seed()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    embeddings_folder = os.path.abspath(os.path.join(script_dir, 'data', vul_type, 'embeddings'))

    desc_file_paths = [
        os.path.join(embeddings_folder, desc_file_path_0),
        os.path.join(embeddings_folder, desc_file_path_1)
    ]
    
    code_file_paths = [
        os.path.join(embeddings_folder, code_file_path_0),
        os.path.join(embeddings_folder, code_file_path_1)
    ]
# a
    combined_desc_data, combined_code_data = load_and_preprocess_data(desc_file_paths, code_file_paths)
    
    combined_desc_file_path = os.path.join(embeddings_folder, 'combined_desc.csv')
    combined_code_file_path = os.path.join(embeddings_folder, 'combined_code.csv')
    combined_desc_data.to_csv(combined_desc_file_path, index=False)
    combined_code_data.to_csv(combined_code_file_path, index=False)

    dataset = CombinedEmbeddingDataset(combined_desc_file_path, combined_code_file_path)

    desc_features = np.array(dataset.desc_embeddings)
    code_features = np.array(dataset.code_embeddings)
    labels = np.array(dataset.labels).reshape(-1, 1)

    # 使用k折交叉验证
    all_metrics = k_fold_cross_validation(desc_features, code_features, labels, k=5)

# Example usage:
# do_train_and_evaluate_MLP('embeddings_desc_0_RAG.csv', 'embeddings_desc_1_RAG.csv', 'embeddings_code_0_RAG.csv', 'embeddings_code_1_RAG.csv', 'some_vul_type')