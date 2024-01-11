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

  # Print the name and the ports of the container
  print(f"Container: {name}")
  print(f"Ports: {ports}")
  print("")
