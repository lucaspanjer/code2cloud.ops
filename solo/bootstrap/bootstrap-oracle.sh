#!/bin/sh

setenv http_proxy www-proxy.us.oracle.com:80
setenv https_proxy www-proxy.us.oracle.com:80

sudo rpm -Uvh http://rbel.frameos.org/rbel6

# old ruby on systems mess us up
sudo yum erase ruby-libs -y

sudo yum install ruby ruby-devel ruby-ri ruby-rdoc ruby-shadow gcc gcc-c++ automake autoconf make curl dmidecode -y

# install ruby gems from source
cd /tmp
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar zxf rubygems-1.8.10.tgz
cd rubygems-1.8.10
sudo ruby setup.rb --no-format-executable


sudo gem install chef --no-ri --no-rdoc

cat <<EOF > platform.patch
140a141,148
>           :oracle   => {
>             :default => {
>               :service => Chef::Provider::Service::Redhat,
>               :cron => Chef::Provider::Cron,
>               :package => Chef::Provider::Package::Yum,
>               :mdadm => Chef::Provider::Mdadm
>             }
>           },
EOF

sudo patch /usr/lib64/ruby/gems/1.8/gems/chef-0.10.8/lib/chef/platform.rb platform.patch

sudo /usr/sbin/useradd vcloud -d /scratch/vcloud


