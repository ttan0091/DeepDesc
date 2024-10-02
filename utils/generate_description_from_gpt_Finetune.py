import os
import json
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
from openai import OpenAI


class GenerateDescriptionFromLLMsFinetune:
    def __init__(self, api_key_file, source_code_dir, commented_code_dir, template_file,vul_type):
        self.script_dir = os.path.dirname(os.path.abspath(__file__))
        self.project_root = os.path.abspath(os.path.join(self.script_dir, '..'))
        
        # Set paths based on script location
        self.api_key_path = os.path.join(self.script_dir, api_key_file)
        self.source_code_dir = os.path.join(self.project_root, 'data',vul_type,source_code_dir)
        self.commented_code_dir = os.path.join(self.project_root, 'data',vul_type,commented_code_dir)
        self.template_path = os.path.join(self.script_dir, template_file)
        
        self.api_key = self._get_api_key()
        self.question_template = self._get_question_template()

    def _get_api_key(self):
        try:
            with open(self.api_key_path, 'r') as file:
                return file.read().strip()
        except FileNotFoundError:
            print(f"API key file not found: {self.api_key_path}")
            return None

    def _get_question_template(self):
        try:
            with open(self.template_path, 'r', encoding='utf-8') as file:
                return file.read().strip()
        except FileNotFoundError:
            print(f"Question template file not found: {self.template_path}")
            return None

    def _ask_chatgpt(self, question):
        client = OpenAI(api_key=self.api_key)
        try:
            response = client.chat.completions.create(
                model="ft:gpt-3.5-turbo-0125:personal::9skBDd5J",
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

    def process_file(self, filename):
        file_path = os.path.join(self.source_code_dir, filename)
        with open(file_path, 'r', encoding='utf-8') as file:
            code = file.read()
            question = f"{self.question_template}\n\nplease do the job according to the code follows: {code}"
            response = self._ask_chatgpt(question)
            time.sleep(1)
            if response is None:
                return f"Error processing {filename}: API request failed."

            try:
                reply = response.choices[0].message.content
            except KeyError:
                print(f"Error processing {filename}: 'choices' not found in response.")
                print(f"Response content: {json.dumps(response, indent=2)}")
                return f"Error processing {filename}"
            
            new_filename = os.path.splitext(filename)[0] + '.txt'
            formatted_file_path = os.path.join(self.commented_code_dir, new_filename)
            
            with open(formatted_file_path, 'w', encoding='utf-8') as formatted_file:
                formatted_file.write(reply)
        
        return f"Processed {filename}"

    def process_all_files(self):
        if not os.path.exists(self.commented_code_dir):
            os.makedirs(self.commented_code_dir)
        
        sol_files = [f for f in os.listdir(self.source_code_dir) if f.endswith(".sol")]

        total_files = len(sol_files)
        progress_bar = tqdm(total=total_files, desc="Processing files", unit="file")

        with ThreadPoolExecutor(max_workers=5) as executor:
            futures = [executor.submit(self.process_file, filename) for filename in sol_files]
            for future in as_completed(futures):
                result = future.result()
                progress_bar.update(1)
        
        progress_bar.close()
        print(f"All files have been processed and saved to {self.commented_code_dir} folder.")

# Example usage:
# processor = GenerateDescriptionFromLLMsRAG('api_key.txt', 'sourcecode_functions_0', 'functions_desc_0', 'question_template.txt')
# processor.process_all_files()