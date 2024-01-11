# Import the docker module
import docker

# Create a docker client object
client = docker.from_env()

# Get the list of all containers
containers = client.containers.list(all=True)

# Loop through each container
for container in containers:
    # Get the name and the ports of the container
    name = container.name
    ports = container.ports

    # Loop through the ports of the container
    for container_port, port_data in ports.items():
        if port_data:
            first_value = next(iter(port_data), {}).get('HostPort', '').split('/')[0]
            # Print the name and the ports of the container
            print(f"{name} {first_value}")
            break  # Break out of the inner loop after printing the first port

    # Print a newline to separate the output for each container
    print()
