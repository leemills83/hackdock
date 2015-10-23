#!/bin/bash

docker build -t hackman/nodejs-server nodejs/
docker build -t hackman/couchdb couchdb/
echo "All built"
