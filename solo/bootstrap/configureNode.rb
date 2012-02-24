#!/usr/bin/ruby

usage='Args: node_ip node_hostname'

if ARGV.length != 2 
  print usage;
  exit(1);
end

hostname=ARGV[1]

# Java setup

# Networking

# Hostname
# edit /etc/sysconfig/network to set the hostname
# edit /etc/hosts?
`hostname #{hostname}`
# restart network