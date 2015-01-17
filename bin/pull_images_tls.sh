#!/bin/bash
export DOCKER_CERT_PATH="`pwd`/tls"
export DOCKER_TLS_VERIFY=1

docker -H tcp://dockerhost01:2376 pull ubuntu:latest &
docker -H tcp://dockerhost02:2376 pull ubuntu:latest &
docker -H tcp://dockerhost03:2376 pull ubuntu:latest

docker -H tcp://dockerhost01:2376 pull nginx:latest &
docker -H tcp://dockerhost02:2376 pull nginx:latest &
docker -H tcp://dockerhost03:2376 pull nginx:latest
