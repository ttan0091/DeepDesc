import os

def remove_chars_from_files(folder_path, chars_to_remove):
    for filename in os.listdir(folder_path):
        if filename.endswith(".txt"):
            file_path = os.path.join(folder_path, filename)
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()
            for char in chars_to_remove:
                content = content.replace(char, '')
            with open(file_path, 'w', encoding='utf-8') as file:
                file.write(content)
                
def run_remove_star(vul_type):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    folder_path3 = os.path.join(script_dir, vul_type,'functions_desc_0')
    folder_path1 = os.path.join(script_dir, vul_type,'functions_desc_1')
    folder_path2 = os.path.join(script_dir, vul_type,'functions_desc_0_RAG')
    folder_path4 = os.path.join(script_dir, vul_type,'functions_desc_1_RAG')
    folder_path5 = os.path.join(script_dir, vul_type,'functions_desc_0_Finetune')
    folder_path6 = os.path.join(script_dir, vul_type,'functions_desc_1_Finetune')
    chars_to_remove = ['*', '`','-']

    remove_chars_from_files(folder_path1, chars_to_remove)
    remove_chars_from_files(folder_path2, chars_to_remove)
    remove_chars_from_files(folder_path3, chars_to_remove)
    remove_chars_from_files(folder_path4, chars_to_remove)
    # remove_chars_from_files(folder_path5, chars_to_remove)
    # remove_chars_from_files(folder_path6, chars_to_remove)

    print("Character removal complete.")
    
# run_remove_star('Integer_Overflow')