#!/bin/bash

docker run -d \
  -e constraint:zone=internal \
  -e constraint:disk=ssd \
  -t ubuntu:latest \
  /bin/bash

docker run -d \
  -e constraint:zone=external \
  -e constraint:disk=ssd \
  -t ubuntu:latest \
  /bin/bash
