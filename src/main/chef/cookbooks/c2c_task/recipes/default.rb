node[:c2c][:server][:artifacts] =
 

include_recipe "c2c_server"

tasksPwd=data_bag_item("secrets", "passwords")["tasks"]
wikiPwd=data_bag_item("secrets", "passwords")["wiki"]

template "#{node.c2c.server.opt}/etc/task.properties" do
  source "task.properties.erb"
  variables :tasksPwd => tasksPwd, :wikiPwd => wikiPwd
  owner node.c2c.user
  group node.tomcat.group
  mode 0660
  notifies :restart, "service[tomcat]"
end

template "#{node.c2c.server.opt}/bin/liquibase-wiki.rb" do
  source "liquibase-wiki.rb.erb"
  variables :wikiPwd => wikiPwd
  owner node.c2c.user
  group node.tomcat.group
  mode 0770
end

template "#{node.c2c.server.opt}/bin/liquibase-tasks.rb" do
  source "liquibase-tasks.rb.erb"
  variables :tasksPwd => tasksPwd
  owner node.c2c.user
  group node.tomcat.group
  mode 0770
end

c2c_server_deployment "task" do 
  artifacts  [ { "name" => "tasks", "package" => "tasks.web" },
                { "name" => "wiki", "package" => "wiki.web" } ]
  action :deploy
  provider "c2c_server_#{node.c2c.server.deploy_type}"
end