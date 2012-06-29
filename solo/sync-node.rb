#!/usr/bin/ruby

require 'rubygems'
require 'net/scp'

usage ="sync <ip> <roles-filename> <env> \n ie sync 192.168.1.100 q-main q-selfhost\n"

if ARGV.length != 3 
  print usage;
  exit(1)
end

top_dir='/opt/workspace/code2cloud.chef' # FIXME make general
opscode_cookbooks_dir="#{top_dir}/../opscode-cookbooks"
node_ip=ARGV[0]
node_port=22
if node_ip.include? ":" then
  idx = node_ip.index(":")
  node_port = node_ip[idx+1, node_ip.size()]
  node_ip = node_ip[0..idx-1]
end

username='vcloud'
host_chef_dir='/opt/code2cloud/chef'

cookbooks="apt apache2 chef-server emacs git java mysql openssh postfix ssh_known_hosts sudo tomcat jpackage maven ntp openssl"

env=ARGV[2]
node_role = ARGV[1]

if !File.exists?("#{top_dir}/roles/#{env}")  
    print "#{env} environment does not exist"
    exit (1)
end

#Net::SSH.start(node_ip, username) do |ssh|
#  ssh.exec!("sudo mkdir -p #{host_chef_dir}/roles")
#  ssh.exec!("sudo mkdir -p #{host_chef_dir}/cookbooks")
#  ssh.exec!("sudo chown -R #{host_chef_dir}")
#end 


def upload(scp, fileGlob, remoteDir)
  for file in Dir.glob(fileGlob)
    scp.upload!(file, remoteDir, :recursive => true) do |ch, name, sent, total|
      if sent == total
        puts "#{name}"
      end
    end
  end
end

# use a persistent connection to transfer files
Net::SCP.start(node_ip, username, :port => node_port) do |scp|  
  print "Using #{env} environment...\n"
  # Environment
  upload(scp, "#{top_dir}/roles/#{env}/*.rb", "#{host_chef_dir}/roles")
  # All Roles (some not needed)
  upload(scp, "#{top_dir}/roles/*.rb", "#{host_chef_dir}/roles")
  # All required Opscode cookbooks
  for cookbook in cookbooks.split(" ")
    upload(scp, "#{opscode_cookbooks_dir}/#{cookbook}", "#{host_chef_dir}/cookbooks")
  end
  # All our cookbooks
  upload(scp, "#{top_dir}/site-cookbooks/*", "#{host_chef_dir}/cookbooks")
  # Solo config
  for file in ["chef-solo.sh", "solo.rb"]
    upload(scp, "#{top_dir}/solo/#{file}", "#{host_chef_dir}")
  end
  upload(scp, "#{top_dir}/solo/node-roles/#{node_role}.json", "#{host_chef_dir}/roles.json")
end

