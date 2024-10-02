import os
import time
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
from openai import OpenAI

class GenerateDescriptionFromLLMsRAG:
    def __init__(self, api_key_file, source_code_dir, commented_code_dir, template_file,vul_type):
        self.script_dir = os.path.dirname(os.path.abspath(__file__))
        self.project_root = os.path.abspath(os.path.join(self.script_dir, '..'))
        
        # Set paths based on script location
        self.api_key_path = os.path.join(self.script_dir, api_key_file)
        self.source_code_dir = os.path.join(self.project_root, 'data',vul_type,source_code_dir)
        self.commented_code_dir = os.path.join(self.project_root, 'data',vul_type,commented_code_dir)
        self.template_path = os.path.join(self.script_dir, template_file)
        
        self.api_key = self._get_api_key()
        
        # Add project root to sys.path
        sys.path.append(self.project_root)
        
        # Import after adding to sys.path
        from generate_vul_reports.rag_enhanced_llm import search_from_reports_embedding
        self.search_from_reports_embedding = search_from_reports_embedding

    def _get_api_key(self):
        try:
            with open(self.api_key_path, 'r') as file:
                return file.read().strip()
        except FileNotFoundError:
            print(f"File not found: {self.api_key_path}")
            return None

    def _get_question_template(self):
        try:
            with open(self.template_path, 'r', encoding='utf-8') as file:
                return file.read()
        except FileNotFoundError:
            print(f"Template file not found: {self.template_path}")
            return None

    def _ask_chatgpt(self, question):
        client = OpenAI(api_key=self.api_key, base_url="https://api.deepseek.com")

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

    def process_file(self, filename):
        file_path = os.path.join(self.source_code_dir, filename)
        with open(file_path, 'r', encoding='utf-8') as file:
            code = file.read()
            question_template = self._get_question_template()
            if question_template is None:
                return f"Error processing {filename}: Template file not found"
            
            find_reports = self.search_from_reports_embedding(code, top_k=1)
            question = f"{question_template}\n\n[REFERENCE VULNERABILITY REPORTS]\n\n{find_reports}\n\nPlease do the job according to the code follows: [TASK CODE]\n{code}"
            
            time.sleep(1)
            response = self._ask_chatgpt(question)
            
            if response is None:
                return f"Error processing {filename}: API request failed."

            try:
                reply = response.choices[0].message.content
            except KeyError:
                print(f"Error processing {filename}: 'choices' not found in response.")
                return f"Error processing {filename}"
            
            new_filename = os.path.splitext(filename)[0] + '.txt'
            formatted_file_path = os.path.join(self.commented_code_dir, new_filename)
            
            with open(formatted_file_path, 'w', encoding='utf-8') as formatted_file:
                formatted_file.write(reply)
                # print(f"Processed {filename}")
        
        return f"Processed {filename}"

    def process_all_files(self):
        if not os.path.exists(self.commented_code_dir):
            os.makedirs(self.commented_code_dir)
        
        sol_files = [f for f in os.listdir(self.source_code_dir) if f.endswith(".sol")]

        total_files = len(sol_files)
        progress_bar = tqdm(total=total_files, desc="Processing files", unit="file")

        with ThreadPoolExecutor(max_workers=100) as executor:
            futures = [executor.submit(self.process_file, filename) for filename in sol_files]
            for future in as_completed(futures):
                result = future.result()
                progress_bar.update(1)
        
        progress_bar.close()
        print(f"All files have been processed and saved to {self.commented_code_dir} folder.")

# Example usage:
# processor = GenerateDescriptionFromLLMsRAG('api_key_deepseek.txt', 'sourcecode_functions_1', 'functions_desc_1_RAG', 'question_template_RAG.md')
# processor.process_all_files()