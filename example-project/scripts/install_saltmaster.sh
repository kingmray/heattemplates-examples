#!/bin/bash

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y avahi-daemon avahi-utils haveged git curl screen bc wget

# nginx version:
# install salt master
apt-get install -y salt-master

mkdir /srv/salt/states
mkdir /srv/salt/pillar

cat <<EOF> /root/.ssh/config
Host *
    StrictHostKeyChecking=no
Host gitlab
    Hostname gitlab.syseleven.de
    IdentityFile ~/.ssh/deploy_key
EOF

git clone git@gitlab.syseleven.de:openstack-spryker/saltstack.git /srv/salt/states
git clone git@gitlab.syseleven.de:openstack-spryker/saltstack-pillar.git /srv/salt/pillar

cat <<EOF> /etc/salt/master
interface: 0.0.0.0
file_roots:
  base:
    - /srv/salt/states
pillar_roots:
  base:
    - /srv/salt/pillar
auto_accept: True
EOF

service salt-master restart

## echo "* * * * * root /usr/local/sbin/update_sessionconfig >> /var/log/sessionconfig.log" > /etc/cron.d/update_sessionstore

logger "finished salt master installation"
