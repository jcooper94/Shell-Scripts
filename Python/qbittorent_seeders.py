import shelve
import qbittorrentapi

#implements asking the user what # of torrent seeders to choose to support a torrent by seeding.  

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
    user = input('What is qBittorent username?')
    password = input('What is qBittorent password?')
    url = f'http://{ip}:{port}/api/v2/torrents/info'
    yes_no = input(f'You typed IP: {ip} PORT: {port} with a username {user} password {password}. \nIs this correct? Type Yes or No \n')

    return yes_no.lower(), url, port, user, password, ip


def get_torrents_list():
    qbt_client = qbittorrentapi.Client(**creds)
    for torrent in qbt_client.torrents_info():
        print(f"{torrent.hash[-6:]}:\n{torrent.name}:\n{torrent.num_complete} total numbers of seeders in the swarm.")

if __name__ == '__main__':
    #opens shelf state file
    with shelve.open('state_storage') as shelf:
        #gets the state if it doesn't exist defaults to true
        current_state = shelf.get('toggle_state', True)
        #print(current_state)
        if current_state:
            #runs setup and returns response and newurl from it
            response, url, port, user, password, ip = setup()
            if response == 'yes':
                #print(url)
                creds = dict(host = ip, port = port, username = user, password = password)
                credentials = shelve.open('credentials')
                credentials['credentials'] = creds
                credentials.close()
                current_state = toggle_state()  # Toggle the state and update current_state
                #print(current_state)  # Print the updated state
            else:
                print('Running setup.')
                setup()
        else:
            print('Not your first time running the script, so not asking for information.')
            elf_on_shelf = shelve.open('credentials')
            creds = elf_on_shelf['credentials']
            #print(creds)
            get_torrents_list()
            elf_on_shelf.close()
