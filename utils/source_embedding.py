import csv
import os
import numpy as np
import pandas as pd
from transformers import BertModel, BertTokenizer

class BertEmbeddingGenerator:
    def __init__(self, model_name='bert-base-cased', max_length=512):
        self.tokenizer = BertTokenizer.from_pretrained(model_name)
        self.model = BertModel.from_pretrained(model_name)
        self.max_length = max_length

    def get_embeddings(self, text):
        inputs = self.tokenizer(text, return_tensors='pt', truncation=True, padding=True, max_length=self.max_length)
        outputs = self.model(**inputs)
        embeddings = outputs.last_hidden_state.mean(dim=1).detach().numpy()
        return embeddings[0]

    def generate_embeddings(self, input_dir_name, output_file_name, label,vul_type):
        # 获取脚本文件夹路径
        script_dir = os.path.dirname(os.path.abspath(__file__))

        # 查找待处理的文件夹路径
        input_dir = os.path.abspath(os.path.join(script_dir, '..', 'data',vul_type,input_dir_name))

        # 验证输入目录是否存在
        if not os.path.isdir(input_dir):
            raise FileNotFoundError(f"The directory {input_dir} does not exist.")

        # 读取待处理的文件夹中的所有文件
        contracts = []
        files_list = os.listdir(input_dir)

        # 过滤仅保留 .sol 和 .txt 文件 a
        files_list = [f for f in files_list if f.endswith('.sol') or f.endswith('.txt')]

        # 检查文件名
        # print("Files found:")
        # for filename in files_list:
        #     print(filename)

        print(f"Total files found: {len(files_list)}")  # 打印文件总数

        for filename in files_list:
            file_path = os.path.join(input_dir, filename)
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
                text = file.read()
                contract_name = os.path.splitext(filename)[0]  # 去除后缀
                contracts.append({
                    "contract_name": contract_name,
                    "text": text,
                    "label": label
                })
        print(f"Total contracts processed: {len(contracts)}")  # 打印处理的文件总数

        # 在脚本文件夹的上级文件夹中创建'embeddings'文件夹
        output_dir = os.path.abspath(os.path.join(script_dir, '..', 'data',vul_type,'embeddings'))
        os.makedirs(output_dir, exist_ok=True)

        # CSV文件路径
        output_file = os.path.join(output_dir, output_file_name)

        # 生成嵌入并保存为CSV文件
        with open(output_file, 'w', newline='') as csvfile:
            fieldnames = ['contract_name', 'embeddings', 'label']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()

            for i, contract in enumerate(contracts):
                embeddings = self.get_embeddings(contract['text'])
                writer.writerow({
                    'contract_name': contract['contract_name'],
                    'embeddings': str(embeddings.tolist()),
                    'label': contract['label']
                })
                # print(f"Processed {i + 1}/{len(contracts)}: {contract['contract_name']}")  # 打印处理进度

        # 验证生成的CSV文件
        df = pd.read_csv(output_file)
        print(df.head())
        return df
