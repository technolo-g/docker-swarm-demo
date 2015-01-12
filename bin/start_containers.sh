#!/bin/bash

docker run -d \
  -p 80 \
  -e constraint:zone=internal \
  -e constraint:disk=ssd \
  -t nginx:latest

docker run -d \
  -p 80 \
  -e constraint:zone=external \
  -e constraint:disk=ssd \
  -t nginx:latest
