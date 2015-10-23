#!/bin/bash

echo "CouchDB"
docker run -d \
    --name couchdb \
    -p 5984:5984 \
    -e COUCHDB_USERNAME=hackman \
    -e COUCHDB_PASSWORD=Welcome123 \
    hackman/couchdb

echo "NodeJS"
docker run -d \
    --name nodejs \
    --link couchdb:couchdb \
    -v $(pwd)/www:/srv/www \
    -p 8080:8080 \
    hackman/nodejs-server

docker ps -a
echo "Online"
