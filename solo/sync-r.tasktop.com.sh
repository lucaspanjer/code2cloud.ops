#!/bin/sh

TOP_DIR="`pwd`/`dirname $0`/../"
SCP="scp -P 50022"
SSH_HOST="vcloud@c2c.tasktop.com"
CHEF_DIR="/opt/code2cloud/chef"
ENV=c2c-ea

if [ ! -d "${TOP_DIR}/roles/${ENV}" ]; then
    echo "'${ENV}' environment does not exist"
    exit 1
fi

echo "Using '${ENV}' environment..."

$SCP ${TOP_DIR}/roles/${ENV}/*.rb $SSH_HOST:$CHEF_DIR/roles
$SCP ${TOP_DIR}/roles/*.rb $SSH_HOST:$CHEF_DIR/roles

CHEF_SERVER_DEPS="build-essential bluepill couchdb daemontools erlang gecode runit openssl ucspi-tcp xml zlib"
COOKBOOKS="apt apache2 chef-server emacs git java mysql openssh postfix ssh_known_hosts sudo tomcat jpackage maven ntp openssl"

#echo "uploading opscode cookbooks..."
#cd $TOP_DIR/../opscode-cookbooks
#$SCP -r $COOKBOOKS $SSH_HOST:$CHEF_DIR/cookbooks

echo "uploading cfc cookbooks..."
cd $TOP_DIR/site-cookbooks/
$SCP -r ./* $SSH_HOST:$CHEF_DIR/cookbooks

echo "uploading solo config..."
$SCP $TOP_DIR/solo/chef-solo.sh $TOP_DIR/solo/solo.rb $SSH_HOST:$CHEF_DIR/
$SCP $TOP_DIR/solo/r-roles.json $SSH_HOST:$CHEF_DIR/roles.json
