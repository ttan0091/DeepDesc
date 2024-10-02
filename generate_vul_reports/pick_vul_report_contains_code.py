import os
import shutil
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
source_report = os.path.join(script_dir, 'reports_desc_vuls')
target_dir = os.path.join(script_dir, 'reports_vuls_picked')

# 确保目标目录存在
if not os.path.exists(target_dir):
    os.makedirs(target_dir)

# 遍历source_report目录中的所有文件
for filename in os.listdir(source_report):
    if filename.endswith('.txt'):  # 假设报告文件是.txt格式
        file_path = os.path.join(source_report, filename)
        
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # 查找"Vulnerable code:"之后的内容
        if 'Vulnerable code:' in content:
            # 检查是否包含```solidity
            if '```solidity' in content:
                # 将整个文件复制到目标目录
                target_file = os.path.join(target_dir, filename)
                shutil.copy2(file_path, target_file)
                print(f"Copied {filename} to {target_file}")
            else:
                print(f"No Solidity code block found in {filename}")
        else:
            print(f"No 'Vulnerable code:' section found in {filename}")

print("Processing complete.")