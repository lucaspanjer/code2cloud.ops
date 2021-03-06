#c2c_disk node.c2c.db.mount #fdisk,etc /dev/sdb & mount

#c2c_backup #mounts nfs backup device on /home/backup

serverRootPwd=data_bag_item("secrets", "passwords")["mysql_server_root_password"]
  
node.mysql.server_root_password = serverRootPwd
node.mysql.server_debian_password = serverRootPwd
node.mysql.server_repel_password = serverRootPwd

include_recipe "mysql::server"

template "c2c-db.cnf" do
  path "/etc/mysql/conf.d/c2c-db.cnf"
  source "c2c-db.cnf.erb"
  mode 0644
end

execute "mv-mysql-datadir" do
  command "mv #{node.mysql.datadir}/* #{node.c2c.db.datadir}/"
  action :nothing
end

execute "apparmor-reload" do
  command "/etc/init.d/apparmor reload"
  action :nothing
end

template "mysqld-apparmor" do
  source "usr.sbin.mysqld.erb"
  path "/etc/apparmor.d/usr.sbin.mysqld"
  action :nothing
  notifies :run, "execute[apparmor-reload]", :immediately
end

#override opscode-mysql cookbook's service "mysql"
service "mysql" do
  provider Chef::Provider::Service::Upstart
  action :nothing
end

directory node.c2c.db.datadir do
  owner "mysql"
  group "mysql"
  mode 0700
  recursive true
  action :create
  notifies :stop, "service[mysql]", :immediately
  notifies :run, "execute[mv-mysql-datadir]", :immediately
  notifies :create, "template[mysqld-apparmor]", :immediately
  notifies :start, "service[mysql]", :immediately
  not_if { File.exists?(node.c2c.db.datadir) }
end



mysql_database "create database" do
  host "localhost"
  username "root"
  password serverRootPwd
  database node.c2c.db.database
  action :create_db
end

grants_path = "#{node['mysql']['conf_dir']}/c2c_grants.sql"
profilePwd=data_bag_item("secrets", "passwords")["profile"]
tasksPwd=data_bag_item("secrets", "passwords")["tasks"]
wikiPwd=data_bag_item("secrets", "passwords")["wiki"]

template grants_path do
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables :database => node.c2c.db.database, :profilePwd => profilePwd, :tasksPwd => tasksPwd, :wikiPwd => wikiPwd
  notifies :run, "execute[c2c-grants]", :immediately
end

execute "c2c-grants" do
  command "/usr/bin/mysql -u root -p#{serverRootPwd} < #{grants_path}"
  action :nothing
end

directory "#{node.c2c.server.opt}/bin/" do
  owner node.c2c.user
  group node.c2c.user
  mode 0700
  recursive true
  action :create
end

s3_access_key_secret=data_bag_item("secrets", "passwords")["s3_access_key_secret"]

template "#{node.c2c.server.opt}/bin/backup-dbs.pl" do
  source "backup-dbs.pl.erb"
  variables :serverRootPwd => serverRootPwd, :s3_access_key_secret => s3_access_key_secret
  owner node.c2c.user
  group node.c2c.user
  mode 0770
end

cron "backup-dbs" do
  hour "1"
  minute "0"
  command "#{node.c2c.server.opt}/bin/backup-dbs.pl"
  user node.c2c.user
  mailto node.c2c.admin_email
end
