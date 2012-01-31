node[:cfc][:server][:artifacts] =
 

include_recipe "cfc_server"

template "#{node.cfc.server.opt}/etc/task.properties" do
  source "task.properties.erb"
  owner node.cfc.user
  group node.tomcat.group
  mode 0660
  notifies :restart, "service[tomcat]"
end

cfc_server_deployment "task" do 
  artifacts  [ { "name" => "tasks", "package" => "tasks.web" },
                { "name" => "wiki", "package" => "wiki.web" } ]
  action :deploy
  provider "cfc_server_#{node.cfc.server.deploy_type}"
end