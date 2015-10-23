#!/bin/bash

docker build -t leemills/nodejs-server nodejs/
docker build -t leemills/couchdb couchdb/
echo "All built"
