#cfc_disk node.cfc.server.home #fdisk,etc /dev/sdb & mount

include_recipe "cfc_server"

#find git binary locations
git = {}
{ :git_core => ["/usr/local/libexec/git-core", "/usr/lib/git-core"],
  :git_bin  => ["/usr/local/bin", "/usr/bin"] }.each do |key,paths|

  git[key] = paths.select { |path| File.exists?("#{path}/git") }.first
end

template "#{node.cfc.server.opt}/etc/scm.properties" do
  source "scm.properties.erb"
  owner node.cfc.user
  group node.tomcat.group
  mode 0660
  variables git
  notifies :restart, "service[tomcat]"
end

template "#{node.tomcat.config_dir}/server.xml" do
  source "server.xml.erb"
  owner node.tomcat.user
  group node.tomcat.group
  mode 0660
  #notifies :restart, "service[tomcat]"
end

directory "#{node.cfc.server.home}/git-root" do
  owner node.tomcat.user
  group node.tomcat.group
end

directory "#{node.cfc.server.home}/maven-repo" do
  owner node.tomcat.user
  group node.tomcat.group
end

cfc_server_deployment "scm" do 
  artifacts [ { "name" => "services", "package" => "services.web" } ]
  action :deploy
  provider "cfc_server_#{node.cfc.server.deploy_type}"
end