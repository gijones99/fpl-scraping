import pandas as pd
from bs4 import BeautifulSoup
from urllib.parse import urljoin
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from constants import FBREF_HOMEPAGE_URL

def get_full_url(url_tail):
    return urljoin(FBREF_HOMEPAGE_URL, url_tail)


def get_teams_table_soup(url, driver, table_tag_id):
    # Load the page using Selenium
    driver.get(url)
    
    wait = WebDriverWait(driver, 10)
    table_wait = wait.until(EC.presence_of_element_located((By.ID, table_tag_id)))

    # create a Beautiful Soup object from the response content
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    return soup

def get_teams_info(soup, table_tag_id):
    # find the table with id 'div_matchlogs_for'
    table = soup.find('table', {'id': table_tag_id})

    # extract the table rows
    rows = table.find_all('tr')

    # extract the data from each row and store it in a list
    url_data = []
    i = 0
    for row in rows:
        i += 1
        team_cell = row.find('td', {'data-stat': 'team'})
        if team_cell:
            team_name = team_cell.find("a").text
            team_url_tail = team_cell.find("a")['href']
            team_uid = team_url_tail.split("/")[3]
            team_url = get_full_url(team_url_tail)
            url_data.append({"Team Name": team_name, "Unique ID": team_uid, "URL Link": team_url})
 
    df = pd.DataFrame(url_data)
    return df