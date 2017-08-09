# Docker Guide

## Create Docker Image Based on Dockerfile
docker build -t [name]/[tag] .

## Run Docker Container Based on Image 

### Interactive
docker run -it --rm -P -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix [image name]

### Daemon
docker run -d -t --rm -P -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix [image name]

## X Server Host Permissions Adjustments
xhost +local:root

xhost -local:root

## Connect to Running Container
docker exec -it [container name or id] env TERM=xterm /bin/bash