import os
import json
from openai import OpenAI

script_dir = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(script_dir, "vulnerability_conversations.jsonl")
api_key_path = os.path.join(script_dir, '..', '..', 'utils', "api_key.txt")

# 检查文件是否存在
if not os.path.isfile(file_path):
    raise FileNotFoundError(f"File not found: {file_path}")

# 从文件中读取 API 密钥
with open(api_key_path, "r") as file:
    api_key = file.read().strip()

# 初始化 OpenAI 客户端
client = OpenAI(api_key=api_key)

# # 从 vulnerability_conversations.jsonl 中读取数据
# training_data = []
# with open(file_path, "r") as f:
#     for line in f:
#         training_data.append(json.loads(line))

# # 上传数据文件
# with open(file_path, "rb") as file:
#     response = client.files.create(file=file, purpose='fine-tune')
# file_id = response.id
# print(f"File ID: {file_id}")
# file_id = 'file-h59psl39655fYwCAQ8sxrRXu'

# # 创建微调任务
# response = client.fine_tuning.jobs.create(
#     training_file=file_id,
#     model="gpt-3.5-turbo"  
# )
# fine_tune_id = response.id
# print(f"Fine-tune Job ID: {fine_tune_id}")

# 获取微调任务状态
fine_tune_id = 'ftjob-9oahin2a1jZ2UBtyv5qWkvRA'
response = client.fine_tuning.jobs.retrieve(fine_tune_id)
print(f"Fine-tune status: {response.status}")

# 注意：微调完成后才能使用新模型
# 使用微调后的模型（需要等待微调完成）
content = """


You are a smart contract development expert.
Please explain the working process of the following code in detail, as thoroughly as possible. 
For example, you need to do the following:
The code I am giving you:
function sumTokensInPeg(
    ...
) internal returns (uint256 totalPeg) {
    ...
}
You need to answer like this：
This code defines an internal function named `sumTokensInPeg`, which ...
Here’s a detailed explanation of how this function works:
...

[code for you to process]
function compoundingAPY(uint pid, uint compoundUnit) 
    view 
    public 
    returns (uint) 
{
    uint __apy = _apy(pid);
    uint compoundTimes = 365 days / compoundUnit;
    uint unitAPY = 1e18 + (__apy / compoundTimes);
    uint result = 1e18;

    for(uint i = 0; i < compoundTimes; i++) {
        result = (result * unitAPY) / 1e18;
    }

    return result - 1e18;
}

"""
response = client.chat.completions.create(
    model='ft:gpt-3.5-turbo-0125:personal::9skBDd5J',
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": content}
    ]
)
print(response.choices[0].message.content)