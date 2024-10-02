# Import GenerateDescriptionFromLLMsRAG class from generate_description_from_gpt_RAG.py file in utils folder, then create a processor object and call process_all_files method.
from utils.generate_description_from_gpt_RAG import GenerateDescriptionFromLLMsRAG
from utils.source_embedding import BertEmbeddingGenerator

from utils.generate_description_from_gpt import GenerateDescriptionFromLLMs
from utils.generate_description_from_gpt_Finetune import GenerateDescriptionFromLLMsFinetune
from classifier_desc import do_train_and_evaluate
from classifier_code_desc import do_train_and_evaluate_MLP
from data.delete_star import run_remove_star
def run_classifier(vul_type):

    # Generate function descriptions from LLMs
    # processor1 = GenerateDescriptionFromLLMs('api_key_deepseek.txt', 'sourcecode_functions_1', 'functions_desc_1', 'question_template.md',vul_type)
    # processor1.process_all_files()
    # processor0 = GenerateDescriptionFromLLMs('api_key_deepseek.txt', 'sourcecode_functions_0', 'functions_desc_0', 'question_template.md',vul_type)
    # processor0.process_all_files()
    
    # processor_RAG1 = GenerateDescriptionFromLLMsRAG('api_key_deepseek.txt', 'sourcecode_functions_1', 'functions_desc_1_RAG', 'question_template_RAG.md',vul_type)
    # processor_RAG1.process_all_files()
    # processor_RAG0 = GenerateDescriptionFromLLMsRAG('api_key_deepseek.txt', 'sourcecode_functions_0', 'functions_desc_0_RAG', 'question_template_RAG.md',vul_type)
    # processor_RAG0.process_all_files()
    
    # processor_Finetune1 = GenerateDescriptionFromLLMsFinetune('api_key.txt', 'sourcecode_functions_1', 'functions_desc_1_Finetune', 'question_template_Finetune.md',vul_type)
    # processor_Finetune1.process_all_files()
    # processor_Finetune0 = GenerateDescriptionFromLLMsFinetune('api_key.txt', 'sourcecode_functions_0', 'functions_desc_0_Finetune', 'question_template_Finetune.md',vul_type)
    # processor_Finetune0.process_all_files()
    
    # run_remove_star(vul_type)
    
    # Generate embeddings based on function descriptions
    # embedding_generator = BertEmbeddingGenerator()
    # embedding_generator.generate_embeddings('functions_desc_1', 'embeddings_desc_1.csv', 1,vul_type)
    # embedding_generator.generate_embeddings('functions_desc_0', 'embeddings_desc_0.csv', 0,vul_type)
    # embedding_generator.generate_embeddings('functions_desc_1_RAG', 'embeddings_desc_1_RAG.csv', 1,vul_type)
    # embedding_generator.generate_embeddings('functions_desc_0_RAG', 'embeddings_desc_0_RAG.csv', 0,vul_type)
    # embedding_generator.generate_embeddings('functions_desc_1_Finetune', 'embeddings_desc_1_Finetune.csv', 1,vul_type)
    # embedding_generator.generate_embeddings('functions_desc_0_Finetune', 'embeddings_desc_0_Finetune.csv', 0,vul_type)
    # embedding_generator.generate_embeddings('sourcecode_functions_1', 'embeddings_code_1.csv', 1,vul_type)
    # embedding_generator.generate_embeddings('sourcecode_functions_0', 'embeddings_code_0.csv', 0,vul_type)
    
    # print()
    # print(vul_type)
    # print('code')
    # do_train_and_evaluate('embeddings_code_0.csv', 'embeddings_code_1.csv',vul_type)
    # print()
    
    # print('desc')
    # do_train_and_evaluate('embeddings_desc_0.csv', 'embeddings_desc_1.csv',vul_type)
    # print()
    
    # print('desc_RAG')
    # do_train_and_evaluate('embeddings_desc_0_RAG.csv', 'embeddings_desc_1_RAG.csv',vul_type)
    # print()
    
    # print('desc_finetune')
    # do_train_and_evaluate('embeddings_desc_0_Finetune.csv', 'embeddings_desc_1_Finetune.csv',vul_type)
    # print()
    
    # print('code_desc')
    # do_train_and_evaluate_MLP('embeddings_desc_0.csv', 'embeddings_desc_1.csv', 'embeddings_code_0.csv', 'embeddings_code_1.csv',vul_type)
    # print()
    
    print('code_desc_RAG')
    do_train_and_evaluate_MLP('embeddings_desc_0_RAG.csv', 'embeddings_desc_1_RAG.csv', 'embeddings_code_0.csv', 'embeddings_code_1.csv',vul_type)
    print()
    
    # print('code_desc_Finetune')
    # do_train_and_evaluate_MLP('embeddings_desc_0_Finetune.csv', 'embeddings_desc_1_Finetune.csv', 'embeddings_code_0.csv', 'embeddings_code_1.csv',vul_type)
    # print()

def main():
    vul_type1 = 'Atomicity_Violations'
    vul_type2 = 'Inconsistent_State_Updates'
    vul_type3 = 'Price_Manipulation'
    vul_type4 = 'Delegate_Call'
    vul_type5 = 'Integer_Overflow'
    vul_type6 = 'Timestamp_Dependency'
    vul_type7 = 'Reentrancy'
    # run_classifier(vul_type1)
    # run_classifier(vul_type2)
    run_classifier(vul_type3)
    
if __name__ == '__main__':
    main() 