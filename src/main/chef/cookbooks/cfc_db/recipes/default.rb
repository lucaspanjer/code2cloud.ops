#cfc_disk node.cfc.db.mount #fdisk,etc /dev/sdb & mount

#cfc_backup #mounts nfs backup device on /home/backup

include_recipe "mysql::server"

template "cfc-db.cnf" do
  path "/etc/mysql/conf.d/cfc-db.cnf"
  source "cfc-db.cnf.erb"
  mode 0644
end

execute "mv-mysql-datadir" do
  command "mv #{node.mysql.datadir}/* #{node.cfc.db.datadir}/"
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

directory node.cfc.db.datadir do
  owner "mysql"
  group "mysql"
  mode 0700
  recursive true
  action :create
  notifies :stop, "service[mysql]", :immediately
  notifies :run, "execute[mv-mysql-datadir]", :immediately
  notifies :create, "template[mysqld-apparmor]", :immediately
  notifies :start, "service[mysql]", :immediately
  not_if { File.exists?(node.cfc.db.datadir) }
end

mysql_database "create database" do
  host "localhost"
  username "root"
  password node.mysql.server_root_password
  database node.cfc.db.database
  action :create_db
end

grants_path = "#{node['mysql']['conf_dir']}/cfc_grants.sql"

template grants_path do
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables :database => node.cfc.db.database
  notifies :run, "execute[cfc-grants]", :immediately
end

execute "cfc-grants" do
  command "/usr/bin/mysql -u root -p#{node.mysql.server_root_password} < #{grants_path}"
  action :nothing
end

directory "#{node.cfc.server.opt}/bin/" do
  owner node.cfc.user
  group node.cfc.user
  mode 0700
  recursive true
  action :create
end

template "#{node.cfc.server.opt}/bin/backup-dbs.pl" do
  source "backup-dbs.pl.erb"
  owner node.cfc.user
  group node.cfc.user
  mode 0770
end

cron "backup-dbs" do
  hour "1"
  minute "0"
  command "#{node.cfc.server.opt}/bin/backup-dbs.pl"
  user node.cfc.user
  mailto node.cfc.admin_email
end
