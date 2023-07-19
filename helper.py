import os

def create_folder(folder_name):
    # Check if the directory exists
    if not os.path.exists(folder_name):
        # If the directory does not exist, create it
        os.makedirs(folder_name)
        