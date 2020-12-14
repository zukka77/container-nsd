#!/bin/sh

if [ ! -f /etc/nsd/nsd_server.pem ]; then
  nsd-control-setup
fi

chown -R $UID:$GID /var/db/nsd/ /etc/nsd

exec $@
