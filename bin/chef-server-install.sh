#!/bin/sh

#installs chef-server (assuming Ubuntu 10.04 base os install)
#http://wiki.opscode.com/display/chef/Package+Installation+on+Debian+and+Ubuntu

echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list

wget -qO - http://apt.opscode.com/packages@opscode.com.gpg.key | sudo apt-key add -
apt-get update

apt-get install -y chef chef-server
apt-get install -y mkpasswd

#knife configuration

knife configure -i -y --defaults -r ""
knife client list || exit $?

CFC_BIN="`dirname $0`"
$CFC_BIN/sync-cookbooks.sh
$CFC_BIN/sync-roles.sh $1

chef-client
knife node run_list add `hostname -f` 'role[cfc-chef-server]'
chef-client
