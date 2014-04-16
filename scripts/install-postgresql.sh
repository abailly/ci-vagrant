#!/bin/sh

PROXY=$1

if [ z$PROXY != "z" ]; then
    export http_proxy=$PROXY
    export https_proxy=$PROXY
fi

# install postgres
sudo yum install -y postgresql-server

# start it
sudo service postgresql initdb
sudo chkconfig postgresql on
sudo service postgresql start

# allow connections for user ciadmin db reviewdb from all interfaces
# need to allow IPv6 connections too...
sudo sed -i -e '/127.0.0.1/i\
host    reviewdb        ciadmin         0.0.0.0/0       trust' /var/lib/pgsql/data/pg_hba.conf
sudo service postgresql reload

# configure DB
sudo -u postgres createuser -ldrS ciadmin
sudo -u postgres createdb -E UTF-8 -O ciadmin reviewdb
sudo -u postgres psql -c "alter user ciadmin with password 'ciadmin'"

# create ciadmin user
sudo adduser ciadmin
cd /home/ciadmin
