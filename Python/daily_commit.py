import os
import datetime
import requests
from bs4 import BeautifulSoup
from git import Repo
from config import github_token

# Ask for the token
token = github_token
# Get today's date
today = datetime.date.today()

# Get the HTML of the GitHub page
url = "https://github.com/jcooper94"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')

# Find the td element with today's date
td = soup.find('td', {'data-date': today.isoformat()})

# If the data-level attribute is 0, make a commit
if td and td.get('data-level') == '0':
    # Clone the repository
    if os.path.exists("./Bash"):
        repo = Repo("./Bash")
        print('Already Exists')
    else:
        repo = Repo.clone_from("https://github.com/jcooper94/Playground/tree/main/Bash.git", "Bash")

      # Corrected line
    # Create a 'bash' directory if it doesn't exist
    bash_dir = os.path.join(repo.working_tree_dir, 'Bash')
    os.makedirs(bash_dir, exist_ok=True)

    # Create a new file with today's date
    file_path = os.path.join(bash_dir, f'{today.isoformat()}.sh')
    with open(file_path, 'w') as f:
        f.write(f'echo "daily commit {today.isoformat()}"\n')

    # Add the file
    repo.git.add(file_path)

    # Make a commit
    repo.git.commit('-m', f'daily commit {today.isoformat()}')

    # Try to push if error then print error
    try:
        # Push to repo
        repo.git.push('origin', 'master', env={'GIT_ASKPASS': token})
        print('Pushed!')
    except:
        print('Error!')