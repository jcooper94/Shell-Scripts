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
  #The items() method returns a view object. The view object contains the key-value pairs of the dictionary, as tuples in a list.
  for container, port_data in ports.items():
    if port_data:
        first_value = next(iter(port_data), {}).get('HostPort', '').split('/')[0]
        print(f"Container: {container} Port: {first_value}")
    else:
        print(f"Container: {container} Port: No port information available")

  # Print the name and the ports of the container
  #print(type(ports))
  print(f"Container: {name}" + '' + "Port: {first_value}")