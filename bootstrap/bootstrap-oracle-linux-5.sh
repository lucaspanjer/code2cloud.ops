#!/bin/sh

export http_proxy=www-proxy.us.oracle.com:80
export https_proxy=www-proxy.us.oracle.com:80

rpm -Uvh http://rbel.frameos.org/rbel5 --httpproxy www-proxy.us.oracle.com

yum install ruby ruby-devel ruby-ri ruby-rdoc ruby-shadow gcc gcc-c++ automake autoconf make curl dmidecode -y

# install ruby gems from source
cd /tmp
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar zxf rubygems-1.8.10.tgz
cd rubygems-1.8.10
ruby setup.rb --no-format-executable
gem install chef --no-ri --no-rdoc

/usr/sbin/useradd vcloud -d /home/vcloud
mkdir -p /opt/code2cloud/chef/roles
mkdir -p /opt/code2cloud/chef/cookbooks
chown -R vcloud /opt/code2cloud
