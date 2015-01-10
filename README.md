# Docker Swarm Etc..

# Requirements
There are a few requirements to get
ansible
sshpass


- /etc/hosts
```
10.100.199.200 dockerswarm01
10.100.199.201 dockerhost01
10.100.199.202 dockerhost02
10.100.199.203 dockerhost03
10.100.199.204 dockerhost04
10.100.199.205 dockerhost05
```

# Starting things up
It is required to generate the SSL certificates required before attempting to
run Vagrant/Ansible.
```
# Generate SSL
./bin/gen_ssl.sh

# Fire up the nodes
vagrant up
```

# Working with the cluster
```
source bin/env
docker ps
```

# Working with the metal
```
cd ansible/

# Configure the Docker hosts
ansible-playbook --ask-pass metal_docker_host.yml

# Pull the docker images
ansible-playbook --ask-pass metal_docker_images.yml

# Start swarm
ansible-playbook --ask-pass metal_docker_swarm.yml

```

## Included Projects

Registrator
- https://github.com/progrium/registrator

Docker Swarm
- https://github.com/docker/swarm

Consul
- https://github.com/hashicorp/consul


