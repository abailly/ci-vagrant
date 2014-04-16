#!/bin/sh
# set proxy for yum

PROXY=$1

if [ z$PROXY != "z" ]; then
    sudo sed -i -e "\$ a\
proxy=$PROXY" /etc/yum.conf
fi
