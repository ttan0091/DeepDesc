import requests
import os
import json
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm


script_dir = os.path.dirname(os.path.abspath(__file__))
api_key_path = os.path.join(script_dir, '..', 'utils', 'api_key_deepseek.txt')

vul_dir = os.path.abspath(os.path.join(script_dir, 'reports_vuls_oracle'))
oracle_desc_dir = os.path.abspath(os.path.join(script_dir, 'reports_desc'))

def get_api_key():
    try:
        with open(api_key_path, 'r') as file:
            api_key = file.read().strip()
    except FileNotFoundError:
        print(f"File not found: {api_key_path}")
        return None
    return api_key

def ask_chatgpt(api_key, question):
    url = "https://api.deepseek.com/v1"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    data = {
        "model": "deepseek-chat",
        "messages": [
            {"role": "user", "content": question}
        ]
    }

    while True:
        try:
            time.sleep(1)
            response = requests.post(url, json=data, headers=headers)
            if response.status_code == 200:
                return response.json()
            elif response.status_code == 429:
                error_message = response.json()
                print(f"Rate limit error: {error_message['error']['message']}")
                retry_after = int(error_message.get('error', {}).get('param', 1))
                print(f"Retrying after {retry_after} seconds...")
                time.sleep(retry_after)
            else:
                print(f"Error: API request failed with status code {response.status_code}")
                print(f"Response: {response.text}")
                return None
        except ValueError as ve:
            print(f"ValueError: {ve}")
            continue
        except TypeError as te:
            print(f"TypeError: {te}")
            continue
        except requests.exceptions.RequestException as re:
            print(f"RequestException: {re}")
            continue
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            continue

def process_file(api_key, filename):
    file_path = os.path.join(vul_dir, filename)
    with open(file_path, 'r', encoding='utf-8') as file:
        code = file.read()
        question_head = """
        The following vulnerability report describes an AMM price oracle manipulation, sandwich attack, or non-AMM price oracle manipulation in a Solidity contract. Based on the vulnerability report below, help me identify the type of vulnerability, the detailed cause of the vulnerability, the specific execution process, the detailed characteristics of the vulnerable code, and the vulnerable code.

        Please output in the following format without any additional content:

        Type of vulnerability: ...
        Cause of vulnerability: ...
        Execution process: ...
        Vulnerable code: ...

        Below is the vulnerability report you need to process:
        """
        question = question_head + code
        response = ask_chatgpt(api_key, question)
        
        if response is None:
            return f"Error processing {filename}: API request failed."

        try:
            reply = response['choices'][0]['message']['content']
        except KeyError:
            print(f"Error processing {filename}: 'choices' not found in response.")
            print(f"Response content: {json.dumps(response, indent=2)}")
            return f"Error processing {filename}"
        exit()
        
        output_file_path = os.path.join(oracle_desc_dir, filename)
        with open(output_file_path, 'w', encoding='utf-8') as new_file:
            new_file.write(reply)
            
    return f"Processed {filename}"

def main():
    api_key = get_api_key()
    if not api_key:
        return
    if not os.path.exists(oracle_desc_dir):
        os.makedirs(oracle_desc_dir)
    
    txt_files = [f for f in os.listdir(vul_dir) if f.endswith(".txt")]

    # Using tqdm to display progress bar
    total_files = len(txt_files)
    progress_bar = tqdm(total=total_files, desc="Processing files", unit="file")

    with ThreadPoolExecutor(max_workers=2) as executor:
        futures = [executor.submit(process_file, api_key, filename) for filename in txt_files]
        for future in as_completed(futures):
            result = future.result()
            print(result)
            progress_bar.update(1)
    
    progress_bar.close()
    print(f"All files have been processed and saved in the {oracle_desc_dir} folder.")

if __name__ == "__main__":
    main()