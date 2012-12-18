directory "#{node.c2c.server.opt}/sql" do
   owner node.c2c.user
   group node.c2c.group
   mode 0771
   recursive true
 end
 
 
 profileDBPassword=data_bag_item("secrets", "passwords")["profile"]
 
 [ "setupLocalServiceHosts.sql"].each do |sql_file|
   template "#{node.c2c.server.opt}/sql/#{sql_file}" do
     source "#{sql_file}.erb"
     owner node.c2c.user
     group node.c2c.group
     mode 0755
     action :create_if_missing
   end
   
   execute "Maybe run #{sql_file}" do
     command "mysql -u profile -p#{profileDBPassword} profile < #{node.c2c.server.opt}/sql/#{sql_file} && " + 
     "sudo -u vcloud touch #{node.c2c.server.opt}/sql/#{sql_file}.ran" 
     creates "#{node.c2c.server.opt}/sql/#{sql_file}.ran"
   end
 end
 

 
 
