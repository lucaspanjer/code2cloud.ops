directory "#{node.c2c.server.opt}/sql" do
   owner node.c2c.user
   group node.c2c.group
   mode 0771
   recursive true
 end
 
 [ "setupLocalServiceHosts.sql"].each do |sql_file|
   template "#{node.c2c.server.opt}/sql/#{sql_file}" do
     source "#{sql_file}.erb"
     owner node.c2c.user
     group node.c2c.group
     mode 0755
     action :create_if_missing
   end
   
   execute "Maybe run #{sql_file}" do
     command "mysql -u profile -p#{node.c2c.mysql_pw.profile} profile < #{node.c2c.server.opt}/sql/#{sql_file} && " + 
     "sudo -u vcloud touch #{node.c2c.server.opt}/sql/#{sql_file}.ran" 
     creates "#{node.c2c.server.opt}/sql/#{sql_file}.ran"
   end
 end
 

 
 
