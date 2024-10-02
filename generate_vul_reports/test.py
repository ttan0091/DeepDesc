import os 
import json
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
from openai import OpenAI

script_dir = os.path.dirname(os.path.abspath(__file__))
source_code = os.path.join(script_dir, 'test_result')
destination_code = os.path.join(script_dir, 'test_picked')

def ask_chatgpt(question):
    client = OpenAI(api_key='sk-aba63b24208b4cc1827d027df63eb863', base_url="https://api.deepseek.com")
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
        return response
    except Exception as e:
        print(f"Error in API request: {str(e)}")
        return None

question_header = """
You are a smart contract development expert.
Please check the vulnerability report I have been giving you ,and identity if the report described a vulnerability of Price Manipulation.
Only answer 'Yes' or 'No',nothing else."""

def process_file(file_path):
    with open(file_path, 'r') as file:
        code = file.read()
    
    question = question_header + "\n" + code
    time.sleep(1)
    response = ask_chatgpt(question)
    print(response.choices[0].message.content.strip().lower() )
    if response and response.choices[0].message.content.strip().lower() == 'yes':
        destination_file = os.path.join(destination_code, os.path.basename(file_path))
        with open(destination_file, 'w') as file:
            file.write(code)
        return True
    return False

def main():
    # Create destination directory if it doesn't exist
    os.makedirs(destination_code, exist_ok=True)

    # Get all files in the source directory
    files = [os.path.join(source_code, f) for f in os.listdir(source_code) if os.path.isfile(os.path.join(source_code, f))]

    # Set the concurrency to 100
    with ThreadPoolExecutor(max_workers=10) as executor:
        # Submit all tasks
        future_to_file = {executor.submit(process_file, file): file for file in files}
        
        # Use tqdm for progress bar
        for future in tqdm(as_completed(future_to_file), total=len(files), desc="Processing files"):
            file = future_to_file[future]
            try:
                future.result()
            except Exception as exc:
                print(f'{file} generated an exception: {exc}')

    print("Processing complete.")

if __name__ == "__main__":
    main()