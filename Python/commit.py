#!/usr/bin/env python3
import os
import datetime
import requests
from bs4 import BeautifulSoup
from git import Repo, GitCommandError
from config import github_token

# Get today's date
today = datetime.date.today()

# Declare repo variable outside the if block
repo = None

# Get the HTML of the GitHub page
url = "https://github.com/jcooper94"
response = requests.get(url)

# Check if the response was successful (status code 200)
if response.status_code == 200:
    print('200')
    soup = BeautifulSoup(response.text, 'html.parser')

    # Find the td element with today's date
    td = soup.find('td', {'data-date': today.isoformat()})
    print('found td')

    # If the data-level attribute is 0 (no pushes to github today), make a commit
    if td and td.get('data-level') == '0':
        print('data is 1')

        # Set the repository path
        repo_path = "/home/autoimmune/commit/Daily/Bash"

        # Check if the repository exists
        if os.path.exists(repo_path):
            repo = Repo(repo_path)
            print("Repository already exists.")
        else:
            # Clone the repository (replace with your repository URL)
            repo_url = f"https://jcooper94:{github_token}@github.com/jcooper94/Daily.git"
            try:
                repo = Repo.clone_from(repo_url, repo_path)
                print("Repository cloned.")
            except GitCommandError as e:
                print(f"Error cloning repository: {e}")
                # Handle the error accordingly
                exit(1)

        # Create a new file with today's date
        file_path = os.path.join(repo_path, f"{today.isoformat()}.sh")
        with open(file_path, "w") as f:
            f.write(f'echo "daily commit {today.isoformat()}"\n')

        # Check if the branch is tracking a remote branch
        if not repo.active_branch.tracking_branch():
            # If not, set up tracking branch to 'origin/main'
            repo.git.branch("--set-upstream-to=origin/main", repo.active_branch.name)
            print("Tracking branch set up.")

        # Add all changes
        if repo.is_dirty(untracked_files=True):
            print("Changes detected. Adding files...")

            repo.git.add(all=True)

            # Commit with today's date
            commit_message = f"daily commit {today.isoformat()}"
            repo.git.commit("-m", commit_message)

            print("Changes committed.")

            # Push to the remote repository
            try:
                repo.git.push("origin", repo.active_branch.name)
                print("Pushed!")
            except GitCommandError as e:
                print(f"Error pushing to the remote repository: {e}")
                # Handle the error accordingly
                exit(1)
        else:
            print("No changes to commit.")
    else:
        print('No data for today.')
else:
    print(f"Failed to retrieve HTML. Status code: {response.status_code}")
    # Handle the error accordingly
    exit(1)

# Print the repository status for debugging
if repo:
    print("Repository status:")
    print(repo.git.status())
