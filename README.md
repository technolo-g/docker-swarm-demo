## Docker Swarm POC
This repository contains a POC of Docker Swarm configured in the following
manner:
- 5 Docker hosts (dockerhost[01:05])
    - Run latest Docker daemon
    - Run a Docker Swarm daemon pointed at Consul
    - Run a Registrator daemon pointed at Consul
- 1 Docker Swarm host (dockerswarm01)
    - Runs Docker Swarm and listens to the Docker port
    - Is the primary interface for the Docker cluster
    - Runs Consul
        - Web UI available at http://dockerswarm01/ui
        - Swarm path of http://dockerswarm01/swarm

## Requirements
There are a few requirements to get
  - Vagrant: https://www.vagrantup.com/downloads.html
  - VirtualBox: https://www.virtualbox.org/wiki/Downloads or VMware: http://www.vmware.com/products/fusion
  - Ansible: `brew install ansible`
  - SSHPass: `brew install https://raw.github.com/eugeneoden/homebrew/eca9de1/Library/Formula/sshpass.rb`
  - /etc/hosts: Allows us to call things by hostname:

    ```
    10.100.199.200 dockerswarm01
    10.100.199.201 dockerhost01
    10.100.199.202 dockerhost02
    10.100.199.203 dockerhost03
    10.100.199.204 dockerhost04
    10.100.199.205 dockerhost05
    ```

## How to use it
Everything can be tried out using Vagrant once the pre-reqs have been installed.
Just follow these simple instructions:

```
# Stand up the environment
vagrant up

# Set your env variables to point at Vagrant
source bin/env

# Pull images down to the docker hosts.
cd ansible/
ansible-playbook vagrant_docker_images.yml

# Interact with Docker as normal
docker ps
docker run --rm -i -t  ubuntu:latest /bin/bash
```

### TLS
TLS is functional as long as Swarm is configured to use the `file` type of
discovery. After generating the certificates, set the following variables for
both the `dockerhosts` and `dockerswarm` groups to run TLS:
- use_tls: true
- docker_port: 2376

The certificates can be generated and the cluster provisioned using the
following commands:
```
# Generate SSL
./bin/gen_ssl.sh

# Provision the cluster
vagrant up

# Set your env to Vagrant + TLS
source bin/env_tls

# Pull images down to the docker hosts.
./bin/pull_images_tls.sh
ansible-playbook vagrant_docker_images.yml

# Interact with the cluster
docker ps
docker run --rm -i -t  ubuntu:latest /bin/bash

```

## Included Projects

Registrator
- https://github.com/progrium/registrator

Docker Swarm
- https://github.com/docker/swarm

Consul
- https://github.com/hashicorp/consul
