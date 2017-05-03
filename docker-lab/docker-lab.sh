#!/bin/bash

echo "Docker Setup"

echo "- Loading Config"
DOCKER_VOLUME="10G"

echo "- Configuring Repository"
# Yum Repo
RELEASE="virt7-docker-common-release"
REPO_FILE="/etc/yum.repos.d/"$RELEASE".repo"
REPO="["$RELEASE"]"
BASEURL="http://cbs.centos.org/repos/"$RELEASE"/x86_64/os/"
GPGCHECK="0"

if [ -f $REPO_FILE ]; then
   > $REPO_FILE
fi
echo $REPO >> $REPO_FILE
echo name=$RELEASE >> $REPO_FILE
echo baseurl=$BASEURL >> $REPO_FILE
echo gpgcheck=$GPGCHECK >> $REPO_FILE
yum update &> /dev/null

echo "- Installing Docker"
yum install -y --enablerepo=$RELEASE docker &> /dev/null

echo "- Creating Users"
{
    useradd user1
    useradd user2
    echo "user1:user1" | chpasswd
    echo "user2:user2" | chpasswd
    groupadd docker
    usermod -a -G docker user1
    usermod -a -G docker user2
} &> /dev/null

echo "- Starting Docker"

echo "Docker Running"
echo "- Server Version:" `docker version --format '{{.Server.Version}}'`
echo "- Client Version:" `docker version --format '{{.Client.Version}}'`