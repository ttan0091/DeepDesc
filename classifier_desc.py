import json
import os
import random
from typing import List, Tuple
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from sklearn.model_selection import train_test_split
from torch.utils.data import DataLoader, TensorDataset
from sklearn.metrics import confusion_matrix, accuracy_score, precision_score, recall_score, f1_score
import pandas as pd
import ast
from torch.optim.lr_scheduler import ReduceLROnPlateau
from sklearn.model_selection import KFold
from torch.optim.lr_scheduler import CosineAnnealingLR

def set_random_seed(seed: int = 6742):
    """Set random seed for reproducibility."""
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.backends.cudnn.deterministic = True

class EmbeddingDataset:
    def __init__(self, data_file: str):
        self.data = pd.read_csv(data_file)
        self.embeddings = [ast.literal_eval(emb)[0] for emb in self.data['embeddings']]
        self.labels = self.data['label'].values

class EmbeddingClassifier(nn.Module):
    def __init__(self, input_dim: int = 768, hidden_dims: List[int] = [512, 256, 128]):
        super(EmbeddingClassifier, self).__init__()
        
        all_dims = [input_dim] + hidden_dims
        
        layers = []
        for i in range(len(all_dims) - 1):
            layers.extend([
                nn.Linear(all_dims[i], all_dims[i+1]),
                nn.BatchNorm1d(all_dims[i+1]),
                nn.ReLU(),
                nn.Dropout(0.3)
            ])
        
        layers.append(nn.Linear(hidden_dims[-1], 1))
        
        self.model = nn.Sequential(*layers)

    def forward(self, x):
        return self.model(x)
    
def k_fold_cross_validation(features, labels, k=5):
    kf = KFold(n_splits=k, shuffle=True, random_state=42)
    
    all_metrics = {
        'accuracies': [], 'precisions': [], 'recalls': [], 'f1_scores': [], 'confusion_matrices': []
    }

    for fold, (train_index, val_index) in enumerate(kf.split(features), 1):
        # print(f"Fold {fold}/{k}")
        
        x_train, x_val = features[train_index], features[val_index]
        y_train, y_val = labels[train_index], labels[val_index]
        
        x_train, y_train = augment_minority_class(x_train, y_train)
        
        train_dataset = TensorDataset(torch.tensor(x_train).float(), torch.tensor(y_train).float())
        val_dataset = TensorDataset(torch.tensor(x_val).float(), torch.tensor(y_val).float())
        train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
        val_loader = DataLoader(val_dataset, batch_size=32, shuffle=False)

        model = EmbeddingClassifier()
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

def augment_minority_class(features: np.ndarray, labels: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """Augment minority class samples to balance the dataset."""
    positive_indices = np.where(labels == 1)[0]
    negative_indices = np.where(labels == 0)[0]
    
    num_positives = len(positive_indices)
    num_negatives = len(negative_indices)
    
    num_copies = num_negatives // num_positives - 1
    
    augmented_features = np.concatenate([features] + [features[positive_indices]] * num_copies)
    augmented_labels = np.concatenate([labels] + [labels[positive_indices]] * num_copies)
    
    shuffle_indices = np.random.permutation(len(augmented_features))
    return augmented_features[shuffle_indices], augmented_labels[shuffle_indices]

def load_and_preprocess_data(file_paths: List[str]) -> pd.DataFrame:
    """Load and preprocess data from multiple CSV files."""
    dataframes = [pd.read_csv(file) for file in file_paths]
    combined_data = pd.concat(dataframes, ignore_index=True)
    combined_data['embeddings'] = combined_data['embeddings'].apply(lambda x: [ast.literal_eval(x)])
    return combined_data

def train_model(model, train_loader, criterion, optimizer, scheduler, epochs):
    for epoch in range(epochs):
        model.train()
        total_loss = 0
        for inputs, targets in train_loader:
            if inputs.size(0) == 1:
                continue  # Skip batch size of 1
            optimizer.zero_grad()
            outputs = model(inputs)
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
        for inputs, targets in test_loader:
            outputs = model(inputs)
            outputs = torch.sigmoid(outputs)
            
            predicted = (outputs > 0.5).float()
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

def do_train_and_evaluate(desc_file_path_0: str, desc_file_path_1: str,vul_type:str):
    set_random_seed()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    embeddings_folder = os.path.abspath(os.path.join(script_dir, 'data',vul_type,'embeddings'))

    file_paths = [
        # os.path.join(embeddings_folder, 'embeddings_desc_0_RAG.csv'),
        # os.path.join(embeddings_folder, 'embeddings_desc_1_RAG.csv')
        os.path.join(embeddings_folder, desc_file_path_0),
        os.path.join(embeddings_folder, desc_file_path_1)
    ]

    combined_data = load_and_preprocess_data(file_paths)
    combined_file_path = os.path.join(embeddings_folder, 'combined_desc.csv')
    combined_data.to_csv(combined_file_path, index=False)

    dataset = EmbeddingDataset(combined_file_path)

    features = np.array(dataset.embeddings)
    labels = np.array(dataset.labels).reshape(-1, 1)

        # 使用k折交叉验证
    all_metrics = k_fold_cross_validation(features, labels, k=5)


# do_train_and_evaluate('embeddings_desc_0_RAG.csv', 'embeddings_desc_1_RAG.csv')