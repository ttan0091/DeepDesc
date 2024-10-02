import os
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
reports_path = os.path.join(script_dir, "reports_original")
destination_dir = os.path.join(script_dir, "reports_vuls")

# 创建保存分割后文件的目录
if not os.path.exists(destination_dir):
    os.makedirs(destination_dir)

# 获取reports_path目录下所有的txt文件
txt_files = [f for f in os.listdir(reports_path) if f.endswith(".txt")]

# 正则表达式匹配 [H-**] 模式
pattern = re.compile(r"(\[H-\d{2}\].*?)(?=\[H-\d{2}\]|$)", re.DOTALL)

for txt_file in txt_files:
    with open(os.path.join(reports_path, txt_file), "r", encoding="utf-8") as file:
        content = file.read()

        # 使用正则表达式分割内容
        matches = pattern.findall(content)

        for match in matches:
            # 提取段落的标识符，例如 [H-01]
            identifier = match[:6]

            # 去除空行和多余的空格
            cleaned_content = match.strip()

            # 生成新的文件名
            new_file_name = f"{os.path.splitext(txt_file)[0]}{identifier}.txt"
            new_file_path = os.path.join(destination_dir, new_file_name)

            # 将内容写入新的文件
            with open(new_file_path, "w", encoding="utf-8") as new_file:
                new_file.write(cleaned_content)

print("分割完成。")
