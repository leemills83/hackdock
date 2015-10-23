#!/bin/bash

echo "Cleaning up with impunity!"

echo "Kill all running containers..."
docker kill $(docker ps -q)

echo "Delete all stopped containers..."
docker rm $(docker ps -a -q)

echo "Delete all 'untagged/dangling' (<none>) images..."
docker rmi $(docker images -q -f dangling=true)
