#!/usr/bin/ruby

require 'rubygems'

usage ="build-deployment <roles-filename> <env-filename> <output-filename> \n"

if ARGV.length != 3 
  print usage;
  exit(1)
end

top_dir='/opt/workspace/code2cloud.chef' # FIXME make general
opscode_cookbooks_dir="#{top_dir}/../opscode-cookbooks"

cookbooks="apt apache2 chef-server emacs git java mysql openssh postfix ssh_known_hosts sudo tomcat jpackage maven ntp openssl"

env=ARGV[1]
node_role = ARGV[0]
output_file = ARGV[2]

if !File.exists?(env)
  print "#{env} environment does not exist"
  exit (1)
end

if File.exists?(output_file)
  FileUtils.rm_rf(output_file)
end
FileUtils.makedirs("#{output_file}/roles")
FileUtils.makedirs("#{output_file}/cookbooks")


# Environment
FileUtils.cp(env, "#{output_file}/roles")

FileUtils.cp(Dir.glob("#{top_dir}/roles/*.rb"), "#{output_file}/roles")
# All required Opscode cookbooks
for cookbook in cookbooks.split(" ")
  FileUtils.cp_r("#{opscode_cookbooks_dir}/#{cookbook}", "#{output_file}/cookbooks")
end
# All our cookbooks
FileUtils.cp_r(Dir.glob("#{top_dir}/site-cookbooks/*"), "#{output_file}/cookbooks")

for file in ["chef-solo.sh", "solo.rb"]
  FileUtils.cp("#{top_dir}/solo/#{file}", "#{output_file}")
end
FileUtils.cp("#{top_dir}/solo/node-roles/#{node_role}.json", "#{output_file}/roles.json")

