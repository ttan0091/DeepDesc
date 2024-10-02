import requests
import os
import json
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
import openai

script_dir = os.path.dirname(os.path.abspath(__file__))
api_key_path = os.path.join(script_dir, '..','..', 'utils', 'api_key.txt')

vul_dir = os.path.abspath(os.path.join(script_dir, 'reports_vuls_picked'))

def get_api_key():
    try:
        with open(api_key_path, 'r') as file:
            api_key = file.read().strip()
    except FileNotFoundError:
        print(f"File not found: {api_key_path}")
        return None
    return api_key

openai.api_key = get_api_key()

def chat_with_gpt(prompt):
    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": prompt}
            ]
        )
        return response.choices[0].message['content']
    except Exception as e:
        return f"An error occurred: {str(e)}"

# 使用示例
if __name__ == "__main__":
    user_input = input("Hello: ")
    response = chat_with_gpt(user_input)
    print("AI response:", response)