import os
import shutil

def get_files_without_extension(folder):
    files = os.listdir(folder)
    files_without_extension = {os.path.splitext(file)[0] for file in files}
    return files, files_without_extension

script_dir = os.path.dirname(os.path.abspath(__file__))
folder_path1 = os.path.join(script_dir, 'sourcecode_functions_0')
folder_path2 = os.path.join(script_dir, 'functions_desc_0_RAG')
target_dir = os.path.join(script_dir, 'functions_code_0_RAG_add')

# 确保目标文件夹存在，如果不存在则创建
os.makedirs(target_dir, exist_ok=True)

# 获取两个文件夹中所有文件的文件名和无后缀文件名
files_in_folder1, files_without_extension1 = get_files_without_extension(folder_path1)
files_in_folder2, files_without_extension2 = get_files_without_extension(folder_path2)

# 找出文件夹1中独有的无后缀文件名
unique_files_without_extension1 = files_without_extension1 - files_without_extension2

print("在文件夹1中独有的文件（忽略后缀）:")
for file in files_in_folder1:
    file_without_extension = os.path.splitext(file)[0]
    if file_without_extension in unique_files_without_extension1:
        print(file)
        source_file = os.path.join(folder_path1, file)
        target_file = os.path.join(target_dir, file)
        shutil.copy2(source_file, target_file)  # 复制文件到目标文件夹