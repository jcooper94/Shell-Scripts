import shelve
import qbittorrentapi
# documentation reference for statuses, states, etc - https://github.com/qbittorrent/qBittorrent/wiki/WebUI-API-(qBittorrent-4.1)

url = 'http://192.168.1.144:8085/api/v2/torrents/info'

def run():
    elf_on_shelf = shelve.open('credentials')
    creds = elf_on_shelf['credentials']
    get_torrents_list(creds)
    elf_on_shelf.close()


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
    num_to_seed = int(input('How many seeders in the swarm would you like the threshold to me?'))
    url = f'http://{ip}:{port}/api/v2/torrents/info'
    yes_no = input(f'You typed IP: {ip} PORT: {port} with a username {user} password {password}. \nIs this correct? Type Yes or No \n')

    return yes_no.lower(), url, port, user, password, ip, num_to_seed


def get_torrents_list(creds):
    login_creds = {
        'username': creds.get('username'),
        'password': creds.get('password'),
        'host': creds.get('host'),
        'port': creds.get('port')
    }
    qbt_client = qbittorrentapi.Client(**login_creds)
    to_remove = []
    allowed_states = {'uploading', 'stalledUP', 'forcedUP'}
    #count = 0
    for torrent in qbt_client.torrents_info():
       #print(torrent.state) #uploading or stalledUp
       #print(type(torrent.state))
       if torrent.state in allowed_states and torrent.num_complete > creds['seed_swarm']:
           #count += 1
           #print(torrent.name)
           #print(torrent.state)
           to_remove.append(torrent.hash)
    for hash in to_remove:
       # print(hash)
        #url = login_creds['host'] + '/' + login_creds['port']
        qbt_client.torrents_delete(delete_files=False, torrent_hashes=hash)
        print('removed:' + hash)
           #print(f"{torrent.hash[-6:]}:\n{torrent.name}:\n{torrent.num_complete} total numbers of seeders in the swarm.")
           #print(type(torrent.num_complete))
           #if torrent.num_complete > creds['seed_swarm']:          

if __name__ == '__main__':
    #opens shelf state file
    with shelve.open('state_storage') as shelf:
        #gets the state if it doesn't exist defaults to true
        current_state = shelf.get('toggle_state', True)
        #print(current_state)
        if current_state:
            #runs setup and returns response and newurl from it
            response, url, port, user, password, ip, num_to_seed = setup()
            if response == 'yes':
                #print(url)
                creds = dict(host = ip, port = port, username = user, password = password, seed_swarm = num_to_seed)
                credentials = shelve.open('credentials')
                credentials['credentials'] = creds
                current_state = toggle_state()
                credentials.close()
                run()  # Toggle the state and update current_state
                #print(current_state)  # Print the updated state
            else:
                print('Running setup.')
                setup()
        else:
            print('Not your first time running the script, so not asking for information.')
            run()