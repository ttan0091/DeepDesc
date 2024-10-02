from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from bs4 import BeautifulSoup
import time
import requests
import re
import os

# 配置Selenium WebDriver
options = webdriver.ChromeOptions()
options.add_argument('--headless')  # 无头模式，不打开浏览器窗口
script_path = os.path.dirname(os.path.abspath(__file__))
service = ChromeService(executable_path=os.path.join(script_path, 'chromedriver'))  
driver = webdriver.Chrome(service=service, options=options)

# 打开页面
driver.get("https://code4rena.com/reports")

# 等待页面加载完成
time.sleep(1)  

# 获取页面内容
html_content = driver.page_source

# 使用BeautifulSoup解析HTML内容
soup = BeautifulSoup(html_content, 'html.parser')

# 查找包含报告链接的所有元素
report_elements = soup.find_all('a', class_='report-tile__report-link')

# 存储每个报告的链接，过滤掉不符合格式的链接
report_links = []
for element in report_elements:
    link = element['href']
    if link.startswith('/reports/') and not link.startswith('http'):
        full_link = "https://code4rena.com" + link
        report_links.append(full_link)


script_path = os.path.dirname(os.path.abspath(__file__))
reports_path = os.path.join(script_path, 'reports_original')

# 爬取每个报告的内容

for link in report_links:

    report_response = requests.get(link)
    report_html_content = report_response.content
    report_soup = BeautifulSoup(report_html_content, 'html.parser')


    # 使用包含 high-risk-findings 的 id 来查找 h1 标签
    high_risk_heading = report_soup.find('h1', id=re.compile('high-risk-findings'))

    if high_risk_heading:
        # 获取High Risk Findings标题下的所有内容
        content = []
        next_node = high_risk_heading.find_next_sibling()
        while next_node and next_node.name not in ['h1']:
            content.append(next_node.get_text(strip=True))
            next_node = next_node.find_next_sibling()

        # 将内容写入txt文件
        doc_path = os.path.join(reports_path, link.split('/')[-1])  # 以报告链接的最后一部分作为文件名
        with open(doc_path + '.txt', 'w', encoding='utf-8') as file:
            for item in content:
                file.write(item + '\n')
            

# 关闭浏览器
driver.quit()