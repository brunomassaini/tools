#!/bin/bash

echo "Loading Configuration"
IP_SERVER_LIST="("`jq -r '.IP_LIST' config.json | sed "s/\"/'/g" | sed 's/\,//g' | sed 's/\[//g' | sed 's/\]//g'`")"
SSHUSER=`jq -r '.SSH_USER' config.json`
SSHKEY=`jq -r '.SSH_KEY' config.json`
echo "- Servers IPs:" $IP_SERVER_LIST

declare -a IP_SERVER_LIST_ARRAY=$IP_SERVER_LIST;

echo "Loading Ninja Commands"
for i in ${!IP_SERVER_LIST_ARRAY[@]} ; do
    echo "Running Commands"
    echo "- Server" `expr $i + 1`":" ${IP_SERVER_LIST_ARRAY[$i]}

    ssh -T -i $SSHKEY $SSHUSER@${IP_SERVER_LIST_ARRAY[$i]} & bash commands.sh
    exit
done

echo "All commands finished"