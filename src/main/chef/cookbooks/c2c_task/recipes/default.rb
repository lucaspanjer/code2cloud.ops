node[:c2c][:server][:artifacts] =
 

include_recipe "c2c_server"

c2c_log4j_config "tasks"
c2c_log4j_config "wiki"

tasksPwd=data_bag_item("secrets", "passwords")["tasks"]
node.set[:c2c][:db][:task][:password] = tasksPwd
wikiPwd=data_bag_item("secrets", "passwords")["wiki"]
node.set[:c2c][:db][:wiki][:password] = wikiPwd
  
  
template "#{node.c2c.server.opt}/etc/task.properties" do
  source "task.properties.erb"
  owner node.c2c.user
  group node.tomcat.group
  mode 0660
  notifies :restart, "service[tomcat]"
end

c2c_server_deployment "task" do 
  artifacts  [ { "name" => "tasks", "package" => "tasks.web" },
                { "name" => "wiki", "package" => "wiki.web" } ]
  action :deploy
  provider "c2c_server_#{node.c2c.server.deploy_type}"
end