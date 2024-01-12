import requests
import shelve
import requests
import json

url = 'http://192.168.1.144:8085/api/v2/torrents/info'

def toggle_state():
    with shelve.open('state_storage') as shelf:
        current_state = shelf.get('toggle_state', True)
        new_state = not current_state
        shelf['toggle_state'] = new_state
    return new_state

def setup():
    ip = input('What is the local IP address of your docker qBittorrent application? ')
    port = input('What port is the qbittorrent docker container running on? ')
    url = f'http://{ip}:{port}/api/v2/torrents/info'
    yes_no = input(f'You typed IP: {ip} PORT: {port}. \nIs this correct? Type Yes or No \n')
    return yes_no.lower(), url

def get_torrents(url):
    torrents = requests.get(url)
    torrents_dict = json.loads(torrents)
    print(torrents_dict)

if __name__ == '__main__':
    #opens shelf state file
    with shelve.open('state_storage') as shelf:
        #gets the state if it doesn't exist defaults to true
        current_state = shelf.get('toggle_state', True)
        #print(current_state)
        if current_state:
            #runs setup and returns response and newurl from it
            response, new_url = setup()
            if response == 'yes':
                print(new_url)
                current_state = toggle_state()  # Toggle the state and update current_state
                print(current_state)  # Print the updated state
            else:
                print('Running setup again.')
                setup()
        else:
            print('Not your first time running the script, so not asking for information.')