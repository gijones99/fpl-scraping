import pandas as pd
from bs4 import BeautifulSoup
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

def load_scorebox_soup(url, driver, tag_id = "scorebox"):
    # Load the page using Selenium
    driver.get(url)
    
    wait = WebDriverWait(driver, 10)
    wait.until(EC.presence_of_element_located((By.CLASS_NAME, tag_id)))

    # create a Beautiful Soup object from the response content
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    return soup

def get_teams_playing_uids(soup):    
    # find the div with id 'scorebox'
    div = soup.find('div', {'class': "scorebox"})

    divs = div.find_all("div", recursive=False, limit=2)
    home_team_div, away_team_div = divs[0], divs[1]
    home_team_uid = home_team_div.find('a')['href'].split('/')[3]
    away_team_uid = away_team_div.find('a')['href'].split('/')[3]

    return [home_team_uid, away_team_uid]


def load_outfield_perf_soup(uids, url, driver):
    # Load the page using Selenium
    driver.get(url)
    
    wait = WebDriverWait(driver, 10)    
    wait.until(EC.presence_of_element_located((By.ID, f"stats_{uids[0]}_summary")))
    wait.until(EC.presence_of_element_located((By.ID, f"stats_{uids[1]}_summary")))

    # create a Beautiful Soup object from the response content
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    return soup

def get_outfield_perf(team_uids, soup):
    df_list = []
    # find the div with id 'stats_teamuid_summary'
    for team_uid in team_uids:
        table = soup.find('table', {'id': f"stats_{team_uid}_summary"})

        data = []
        table_headers = table.find_all('th')

        # retrive column headers (aka names of the statistics)
        first_index_stat_header = 7
        last_index_stat_header = 37
        col_stats_names = [header.get('aria-label') for header in table_headers][first_index_stat_header:(last_index_stat_header + 1)] # ignore 0-6, take 7-37
        col_stats_names.insert(0, "player_uid")
        col_stats_names.insert(0, "team_uid")

        # retrieve player names
        player_info = table_headers[(last_index_stat_header + 1):-1] # omit the last row since its an aggregation row.
        player_names = [player.get_text().strip() for player in player_info]
        player_uid = [player.find('a')['href'].split('/')[3] for player in player_info]
        
        table_body = table.find('tbody')

        rows = table_body.find_all('tr')
        row_index = 0
        for row in rows:
            cols = row.find_all('td')
            cols = [ele.text.strip() for ele in cols]
            cols.insert(0, player_names[row_index])
            cols.insert(0, player_uid[row_index])
            cols.insert(0, team_uid)
            row_index += 1
            data.append(cols)

        # Convert data to DataFrame
        df = pd.DataFrame(data, columns = col_stats_names)
        df_list.append(df)

    final_match_df = pd.concat(df_list, ignore_index=True)
    return final_match_df

# same as the above but with Passing statistics, impt for the xA statistic.
def get_outfield_perf_extended(team_uids, soup):
    df_list = []
    # find the div with id 'stats_{team_uid}_summary' or stats_{team_uid}_passing
    for team_uid in team_uids:
        summ_table = soup.find('table', {'id': f"stats_{team_uid}_summary"})
        pass_table = soup.find("table", {"id": f"stats_{team_uid}_passing"})

        data = []
        summ_table_headers = summ_table.find_all('th')
        pass_table_headers = pass_table.find_all('th')

        ## retrive column headers (aka names of the statistics) ##
        # summary table
        first_index_stat_header = 7
        last_index_stat_header = 37
        col_stats_names = [header.get('aria-label') for header in summ_table_headers][first_index_stat_header:(last_index_stat_header + 1)] # ignore 0-6, take 7-37
        col_stats_names.insert(0, "player_uid")
        col_stats_names.insert(0, "team_uid")
        
        # passing table
        pass_first_index_stat_header = 13
        pass_last_index_stat_header = 34
        pass_stats_names = [header.get('aria-label') for header in pass_table_headers][pass_first_index_stat_header:(pass_last_index_stat_header + 1)] # ignore 0-5, take 6-28

        col_stats_names.extend(pass_stats_names)

        # retrieve player names
        player_info = summ_table_headers[(last_index_stat_header + 1):-1] # omit the last row since its an aggregation row.
        player_names = [player.get_text().strip() for player in player_info]
        player_uid = [player.find('a')['href'].split('/')[3] for player in player_info]
        
        ## retrieve table data for Summary and Passing data
        summ_table_body = summ_table.find('tbody')
        summ_rows = summ_table_body.find_all('tr')

        pass_table_body = pass_table.find('tbody')
        pass_rows = pass_table_body.find_all('tr')

        row_index = 0
        for summ_row, pass_row in zip(summ_rows, pass_rows):

            summ_cols = summ_row.find_all('td')
            cols = [ele.text.strip() for ele in summ_cols]

            pass_cols = pass_row.find_all('td')[5:] # ignoring info that we have already retrieved earlier
            pass_cols = [ele.text.strip() for ele in pass_cols]

            cols.extend(pass_cols)
            cols.insert(0, player_names[row_index])
            cols.insert(0, player_uid[row_index])
            cols.insert(0, team_uid)
            row_index += 1
            data.append(cols)

        # Convert data to DataFrame
        df = pd.DataFrame(data, columns = col_stats_names)
        df_list.append(df)

    final_match_df = pd.concat(df_list, ignore_index=True)
    return final_match_df


def load_keeper_perf_soup(uids, url, driver):
    # Load the page using Selenium
    driver.get(url)
    
    wait = WebDriverWait(driver, 10)    
    wait.until(EC.presence_of_element_located((By.ID, f"keeper_stats_{uids[0]}")))
    wait.until(EC.presence_of_element_located((By.ID, f"keeper_stats_{uids[1]}")))

    # create a Beautiful Soup object from the response content
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    return soup

def get_keeper_perf(team_uids, soup):

    df_list = []
    # find the div with id 'keeper_stats_{team_uid}'
    for team_uid in team_uids:
        table = soup.find('table', {'id': f"keeper_stats_{team_uid}"})

        data = []
        table_headers = table.find_all('th')

        # retrive column headers (aka names of the statistics)
        first_index_stat_header = 7
        last_index_stat_header = 30
        col_stats_names = [header.get('aria-label') for header in table_headers][first_index_stat_header:(last_index_stat_header + 1)] # ignore 0-6, take 7-30
        col_stats_names.insert(0, "player_uid")
        col_stats_names.insert(0, "team_uid")

        # retrieve player names
        player_info = table_headers[(last_index_stat_header + 1):] # retrieve all keepers that played
        player_names = [player.get_text().strip() for player in player_info]

        table_body = table.find('tbody')

        rows = table_body.find_all('tr')
        row_index = 0
        for row in rows:
            cols = row.find_all('td')
            player_uid = row.find('th', {'data-stat': "player"}).get('data-append-csv').strip()
            cols = [ele.text.strip() for ele in cols]
            cols.insert(0, player_names[row_index])
            cols.insert(0, player_uid)
            cols.insert(0, team_uid)
            row_index += 1
            data.append(cols)

        # Convert data to DataFrame
        df = pd.DataFrame(data, columns = col_stats_names)
        df_list.append(df)

    final_match_df = pd.concat(df_list, ignore_index=True)
    return final_match_df

def load_match_soup(url, driver, tag_id = "scorebox"):
    # Load the page using Selenium
    driver.get(url)
    
    wait = WebDriverWait(driver, 10)    

    # waiting till scorebox appears
    wait.until(EC.presence_of_element_located((By.CLASS_NAME, tag_id)))

    # wait until at least two elements with id starting with 'id_???_summary' are present in the DOM
    wait.until(lambda d: len(d.find_elements(By.CSS_SELECTOR, "[id^='stats_'][id$='_summary']"))>=2)

    # wait until at least two elements with id starting with 'keeper_stats_???' are present in the DOM
    wait.until(lambda d: len(d.find_elements(By.CSS_SELECTOR, "[id^='keeper_stats_']"))>=2)

    # create a Beautiful Soup object from the response content
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    return soup

def load_match_soup_combined(url, driver, tag_id="scorebox"):
    driver.get(url)

    # define a lambda function that will return True when all conditions are met
    conditions_met = lambda d: (
        EC.presence_of_element_located((By.CLASS_NAME, tag_id))(d) and 
        len(d.find_elements(By.CSS_SELECTOR, "[id^='stats_'][id$='_summary']")) >= 2 and
        len(d.find_elements(By.CSS_SELECTOR, "[id^='keeper_stats_']")) >= 2
    )

    # use WebDriverWait to wait until all conditions are met
    WebDriverWait(driver, 10).until(conditions_met)

    # create a Beautiful Soup object from the response content
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    return soup


def retrieve_match_soup_info_to_df(match_soup):
    team_uids = get_teams_playing_uids(match_soup)
    outfield_df_whole = get_outfield_perf_extended(team_uids, match_soup)
    keeper_df_whole = get_keeper_perf(team_uids, match_soup)
    return [outfield_df_whole, keeper_df_whole]