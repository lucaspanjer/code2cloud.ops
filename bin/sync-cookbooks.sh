#!/bin/sh

CHEF_SERVER_DEPS="build-essential bluepill couchdb daemontools erlang gecode runit openssl ucspi-tcp xml zlib"
COOKBOOKS="apt apache2 chef-server emacs git java mysql openssh postfix ssh_known_hosts sudo tomcat jpackage maven ntp"

#echo "uploading opscode cookbooks..."
#knife cookbook upload -o "`dirname $0`/../../opscode-cookbooks" $CHEF_SERVER_DEPS $COOKBOOKS

echo "uploading cfc cookbooks..."
#sync all site-cookbooks
knife cookbook upload -o "`dirname $0`/../site-cookbooks" -a

