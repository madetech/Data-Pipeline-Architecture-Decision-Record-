import requests
import pandas as pd
import time 
from json.decoder import JSONDecodeError

# requests.Session 
# http.client 


# 'https://fakestoreapi.com/products'
def get_requests(endpoint_url : str, starting_record_number : int, rate_limit : int=0, all=True):
    if all:
        # Get all of the data in one full chunk 
        response = requests.get(endpoint_url)
        if response.status_code == 200:
            print(response.json())
        return list(response.json())
    else:
        # Get the data one record at a time.
        request_list = []
        # Iterate through the list of records from the API
        # Iterate such that the range of values are dynamic
        while True:
            # url = f"{endpoint_url}/{number}"
            # print(url)
            try:
                response = requests.get(f"{endpoint_url}/{starting_record_number}")
                status_code = response.status_code
                print(status_code)
                if status_code == 200:
                    print(response.json())
                    request_list.append(response.json())
                    starting_record_number += 1
                    time.sleep(rate_limit)
                else:
                    print(f"No more records {status_code}")
                    break 
            except JSONDecodeError:
                print('Unable to parse record. Breaking the loop')
                break 

        return request_list


def data_to_dataframe(data):
    df = pd.DataFrame(data)
    return df 

def save_file(dataframe : pd.DataFrame, file_name : str, file_type : str):
    if file_type == 'csv':
        dataframe.to_csv(file_name, index=False)

def file_transfer_to_s3():
    pass       

if __name__ == '__main__':
    list_of_requests = get_requests('https://fakestoreapi.com/products', 1, rate_limit=2, all=False)
    print(list_of_requests)
    print(len(list_of_requests))
    result_data = data_to_dataframe(list_of_requests)
    print(result_data)

