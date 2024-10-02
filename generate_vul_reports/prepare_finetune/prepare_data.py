import os
import json

script_dir = os.path.dirname(os.path.abspath(__file__))
source_dir = os.path.join(script_dir, 'reports_vuls_picked')
target_dir = script_dir

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # 查找 'Vulnerable code: ' 的位置
    split_point = content.find('Vulnerable code: ')
    
    if split_point == -1:
        print(f"'Vulnerable code: ' not found in {file_path}")
        return None

    # 提取 completion 和 prompt
    completion = content[:split_point].strip()
    prompt_content = content[split_point + len('Vulnerable code: '):].strip()

    # 构建对话格式
    conversation = {
        "messages": [
            {
                "role": "system",
                "content": "You are an expert in the Solidity programming language. Provide a description and detailed execution process based on the code provided. Be concise and professional."
            },
            {
                "role": "user",
                "content": f"Analyze this Solidity code:\n\n{prompt_content}"
            },
            {
                "role": "assistant",
                "content": completion
            }
        ]
    }

    return conversation

def main():
    output_file = os.path.join(target_dir, 'vulnerability_conversations.jsonl')
    processed_count = 0

    with open(output_file, 'w', encoding='utf-8') as jsonl_file:
        for filename in os.listdir(source_dir):
            if filename.endswith('.txt'):
                file_path = os.path.join(source_dir, filename)
                result = process_file(file_path)
                if result:
                    json.dump(result, jsonl_file, ensure_ascii=False)
                    jsonl_file.write('\n')
                    processed_count += 1

    print(f"Processed {processed_count} files. Output saved to {output_file}")

if __name__ == "__main__":
    main()