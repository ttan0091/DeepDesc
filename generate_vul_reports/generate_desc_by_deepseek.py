import requests
import os
import json
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
from openai import OpenAI

script_dir = os.path.dirname(os.path.abspath(__file__))
api_key_path = os.path.join(script_dir, '..', 'utils', 'api_key_deepseek.txt')

vul_dir = os.path.abspath(os.path.join(script_dir, 'reports_vuls'))
oracle_desc_dir = os.path.abspath(os.path.join(script_dir, 'reports_desc_vuls'))

def get_api_key():
    try:
        with open(api_key_path, 'r') as file:
            api_key = file.read().strip()
        print("API key loaded successfully.")
        return api_key
    except FileNotFoundError:
        print(f"File not found: {api_key_path}")
        return None

def ask_chatgpt(api_key, question):
    print("Sending request to DeepSeek API...")
    client = OpenAI(api_key=api_key, base_url="https://api.deepseek.com")

    try:
        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": "You are a helpful assistant"},
                {"role": "user", "content": question}
            ],
            stream=False,
            timeout=120  
        )
        print("Response received from DeepSeek API.")
        return response
    except Exception as e:
        print(f"Error in API request: {str(e)}")
        return None

def process_file(api_key, filename):
    print(f"Processing file: {filename}")
    file_path = os.path.join(vul_dir, filename)
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            code = file.read()
            question_head = """
            The following vulnerability report describes a vulnerability in a Solidity contract. Based on the vulnerability report below, help me identify the type of vulnerability, the detailed cause of the vulnerability, the specific execution process, and the vulnerable code.

            Please output in the following format without any additional content:

            Type of vulnerability: ...
            Cause of vulnerability: ...
            Execution process: ...
            Vulnerable code: ...

            Below is the vulnerability report you need to process:
            """
            question = question_head + code
            time.sleep(1)
            response = ask_chatgpt(api_key, question)
            
            if response is None:
                return f"Error processing {filename}: API request failed."

            reply = response.choices[0].message.content
            
            output_file_path = os.path.join(oracle_desc_dir, filename)
            with open(output_file_path, 'w', encoding='utf-8') as new_file:
                new_file.write(reply)
                
        return f"Processed {filename}"
    except Exception as e:
        print(f"Error processing {filename}: {str(e)}")
        return f"Error processing {filename}"

def main():
    api_key = get_api_key()
    if not api_key:
        return
    if not os.path.exists(oracle_desc_dir):
        os.makedirs(oracle_desc_dir)
    
    txt_files = [f for f in os.listdir(vul_dir) if f.endswith(".txt")]
    print(f"Found {len(txt_files)} files to process.")

    total_files = len(txt_files)
    progress_bar = tqdm(total=total_files, desc="Processing files", unit="file")

    with ThreadPoolExecutor(max_workers=20) as executor:  
        futures = [executor.submit(process_file, api_key, filename) for filename in txt_files]
        for future in as_completed(futures):
            result = future.result()
            print(result)
            progress_bar.update(1)
    
    progress_bar.close()
    print(f"All files have been processed and saved in the {oracle_desc_dir} folder.")

if __name__ == "__main__":
    main()