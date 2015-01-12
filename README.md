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
        - Consul provides service discovery via its key/value store
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

### Swarm configuration
The Swarm daemon has a few configuration options that are available. They
include:
- Discovery
- Scheduling
- TLS (config described above)

#### Swarm discovery
Swarm supports multiple discovery mechanisms including:
- File (supported here)
- Consul (supported here)
- EtcD
- Zookeeper
- Hosted service (Docker Hub?)

**File Discovery**: Uses a static file with a list of Docker hosts. Swarm is
  pointed at this list and will create a cluster based on it's contents. This is
  the most basic discovery method and is enabled by default in this project
  (though currently the project is configured for Consul).
  The format of the list should be the following:
  ```
  http<s>://< hostname1 >:< port >
  http<s>://< hostname2 >:< port >
  http<s>://< hostname3 >:< port >
  http<s>://< hostname4 >:< port >
  ```

**Consul Discovery**: This configuration mode is what this project is configured
  to use currently. It relies on Consul's key/value store being located on
  the Swarm host (dockerswarm01) at /swarm. In addition to maintaining the Swarm
  cluster, this Consul host also is the endpoint Registrator uses for service
  discovery under the path /services.

#### Swarm Scheduling
At this point in time, Swarm supports two scheduling modes with one in progress:
- **Binpacking:** pack a machine based on a static set of resources
- **Random:** Pick a host at random
- **Balanced:** Pack machines evenly (In-Progress https://github.com/docker/swarm/pull/227)

Swarm uses the scheduling configuration in combination with tags in the Docker
daemon's startup configs to enable control over how to pack the machines. You
can edit the various tags on a machine-by-machine basis by editing the host
specific configs found in `ansible/host_vars/<hostname>.yml` and then specifying
a constraint. An example of a Docker run line for a host in the cluster would be:
```
docker --label zone=external \
  --label disk=ssd \
  -H tcp://0.0.0.0:2375
```

An example that will start an Nginx container on the above node through Swarm
could be:
```
docker run -d \
  -p 80 \
  -e constraint:zone=external \
  -e constraint:disk=ssd \
  -t nginx:latest
```

The above configuration will start an Nginx server on a Docker host in the Swarm
cluster that has been tagged with `zone=external` and `disk=ssd`. Since there
are ports published, registrator will also pick this up and upsert a value into
the `/services/nginx-80` key in Consul with the value of "ipaddress:port" of the
running container.

## Included Projects

Registrator
- https://github.com/progrium/registrator

Docker Swarm
- https://github.com/docker/swarm

Consul
- https://github.com/hashicorp/consul
