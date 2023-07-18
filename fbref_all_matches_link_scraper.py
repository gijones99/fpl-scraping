import pandas as pd
from bs4 import BeautifulSoup
from urllib.parse import urljoin
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from webdriver_manager.chrome import ChromeDriverManager

def load_scores_table_soup(url, driver, tag_id = "sched_2022-2023_9_1"):
    # Load the page using Selenium
    driver.get(url)
    
    wait = WebDriverWait(driver, 10)
    wait.until(EC.presence_of_element_located((By.ID, tag_id)))

    # create a Beautiful Soup object from the response content
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    return soup

def get_matches_info(soup):

    table_headers = soup.find("thead").find_all('th')
    col_names = [header.get("aria-label").strip() for header in table_headers]

    rows = soup.find("table", {"id": "sched_2022-2023_9_1"}).find("tbody").find_all("tr")

    table_data = []
    for row in rows:
        matchweek_num = row.find('th')

        td_cells = row.find_all('td')
        # cols = [cell.text.strip() if i != len(col_names)-2 and i != 3 and i != 8 else cell.find('a')["href"] for i, cell in enumerate(td_cells)]
        cols = [cell.text.strip() if i != 3 and i != 7 and i != len(col_names)-3 else cell.find('a')["href"] if cell.find('a') else None for i, cell in enumerate(td_cells)]
        # cols = [cell.text.strip() if i != 3 and i != 7 and i != 11 else cell.find('a')["href"] if cell.find('a') else None for i, cell in enumerate(td_cells)]
        cols.insert(0, matchweek_num.text.strip()) # match week is in th

        table_data.append(cols)
        
    
    # Create a pandas DataFrame from the scraped data
    df = pd.DataFrame(table_data, columns=col_names)

    col_names = ["Home", "Away", "Match Report"]
    for col in col_names:
        df[f"{col}_uid"] = df[f"{col}"].apply(lambda x: x.split("/")[3] if x is not None else None)

    return df