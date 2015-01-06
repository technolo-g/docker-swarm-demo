# Docker Swarm Etc..

# Requirements

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
