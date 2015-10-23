#!/bin/bash
# Starts up Nginx within the container.

# Stop on error
set -e

DATA_DIR=/srv/www
LOG_DIR=/var/log

# Check if the data directory does not exist.
if [ ! -d "$LOG_DIR/nginx" ]; then
  mkdir -p "$LOG_DIR/nginx"
fi

if [[ -e /first_run ]]; then
  source /scripts/first_run.sh
else
  source /scripts/normal_run.sh
fi

chown -R www-data: "$LOG_DIR/nginx"

# configure couchdb with cors for pouch support
 ln -s /usr/bin/nodejs /usr/bin/node
 npm install -g add-cors-to-couchdb && \
 add-cors-to-couchdb
