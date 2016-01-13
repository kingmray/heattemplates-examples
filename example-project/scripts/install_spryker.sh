#!/bin/bash

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y avahi-daemon avahi-utils haveged git curl screen bc wget salt-minion

cat <<EOF> /etc/salt/minion
master: saltmaster.local
EOF

service salt-minion restart

#echo "* * * * * root /usr/local/sbin/update_sessionconfig >> /var/log/sessionconfig.log" > /etc/cron.d/update_sessionstore

logger "finished appserver installation"
