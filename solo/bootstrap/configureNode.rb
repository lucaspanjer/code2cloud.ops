#!/usr/bin/ruby

usage='Args: node_ip node_hostname\n'

if ARGV.length != 2 
  print usage;
  exit(1);
end

ip_address=ARGV[0]
hostname=ARGV[1]

# Networking
ifcfg_filename="/etc/sysconfig/network-scripts/ifcfg-eth0"
content = File.read(ifcfg_filename)
migrated_content = content.gsub(/IPADDR=.*/, "IPADDR=#{ip_address}")
File.open(ifcfg_filename, 'w') {|f| f.write(migrated_content) }
print `/etc/init.d/network restart`
  
# Hostname
# edit /etc/sysconfig/network to set the hostname
# edit /etc/hosts?
print `hostname #{hostname}`
# restart network