#!/usr/bin/env python3
import os
import datetime
import requests
from bs4 import BeautifulSoup
from git import Repo

# Get today's date
today = datetime.date.today()

# Get the HTML of the GitHub page
url = "https://github.com/jcooper94"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')

# Find the td element with today's date
td = soup.find('td', {'data-date': today.isoformat()})
# If the data-level attribute is 0, make a commit
if td and td.get('data-level') == ('0'):
    # Clone the repository
    if os.path.exists("./Playground"):
        repo = Repo("./Playground")
        print('Already Exists')
    else:
        repo = Repo.clone_from("https://github.com/jcooper94/Playground.git", "Playground")
    # Create a new file with today's date
    file_path = os.path.join('/home/autoimmune/commit/Playground/Bash', f'{today.isoformat()}.sh')
    with open(file_path, 'w') as f:
        f.write(f'echo "daily commit {today.isoformat()}"\n')

    # Check if there are changes
    if repo.is_dirty():
        repo.git.add(file_path)
        print(file_path)
        # Make a commit
        repo.git.commit('-m', f'daily commit {today.isoformat()}')
        # Push to repo
        repo.git.push('origin', 'main')
        print('Pushed!')
    else:
        print('No changes to commit.')