#base recipe for hmaster, hub, scm and task


# FIXME, not sure why this is needed
#c2c_user node.tomcat.user

include_recipe "tomcat::default"
include_recipe "etchosts::default"
include_recipe "ntp"


if node.c2c.server.backup.enabled
  package "duplicity"
  package "python-boto" # for duplicity over s3
  package "ssmtp" # For smtp over gmail
end

directory node.c2c.server.home do
  owner node.c2c.user
  group node.c2c.group
  mode 0771
  recursive true
end

directory node.c2c.server.opt do
  owner node.c2c.user
  group node.c2c.group
  mode 0771
  recursive true
end

node.c2c.server.opt_sym_links.each do |opt_link|
  link opt_link do
    to node.c2c.server.opt
    owner node.c2c.user
    group node.tomcat.group
  end
end

  
link "#{node.c2c.server.opt}/webapps" do
  to node.tomcat.webapp_dir
  owner node.c2c.user
  group node.tomcat.group
end

link "#{node.c2c.server.opt}/tc_logs" do
  to node.tomcat.log_dir
  owner node.c2c.user
  group node.c2c.group
end


execute "usermod -a -G #{node.tomcat.user} #{node.c2c.user}" do
   # FIXME NOT IF ??
end

execute "usermod -a -G adm #{node.c2c.user}" do
   # FIXME NOT IF ??
end

execute "usermod -a -G #{node.c2c.user} #{node.tomcat.user}" do
   # FIXME NOT IF ??
end

directory "#{node.c2c.server.opt}/etc/" do
  owner node.c2c.user
  group node.c2c.group
  recursive true
  action :create
end

directory "#{node.c2c.server.opt}/bin" do
  owner node.c2c.user
  group node.c2c.group
  recursive true
end

if node.c2c.server.backup.enabled

  s3_access_key_secret=data_bag_item("secrets", "passwords")["s3_access_key_secret"]
  template "#{node.c2c.server.opt}/bin/backup-dirs.pl" do
    source "backup-dirs.pl.erb"
    variables :s3_access_key_secret => s3_access_key_secret
    owner node.c2c.user
    group node.c2c.user
    mode 0770
  end
  
  admin_mail_sender_password=data_bag_item("secrets", "passwords")["admin_mail_sender_password"]

  template "/etc/ssmtp/ssmtp.conf" do
    source "ssmtp.conf.erb"
    variables :admin_mail_sender_password => admin_mail_sender_password
    mode 0774
  end
  
  template "/etc/ssmtp/revaliases" do
    source "revaliases.erb"
    mode 0774
  end
  
  
  cron "backup-dirs" do
    hour "1"
    minute "0"
    command "#{node.c2c.server.opt}/bin/backup-dirs.pl"
    user node.c2c.user
    mailto node.c2c.admin_email
  end

  cookbook_file "#{node.c2c.server.opt}/etc/backup_pubkey.txt" do
    source "backup_pubkey.txt"
    owner node.c2c.user
    group node.c2c.user
  end
  
  execute "gpg: import" do
    not_if "sudo -u #{node.c2c.user} gpg --list-keys #{node.c2c.server.backup.key_name}"
    #FIXME should use a property for this sig                                                                                                      
    command "gpg --import #{node.c2c.server.opt}/etc/backup_pubkey.txt && echo D18422C06DA0E931CBEBE73C99F305CB48F1289B:6: | gpg --import-ownertrust"
    user node.c2c.user
    action :run
  end
end

cookbook_file "/etc/security/limits.conf" do
  mode 0644
end

cookbook_file "/etc/pam.d/common-session" do
  mode 0644
end


if node.c2c.server.build
  artifacts = node.c2c.server.artifacts
else
  artifacts = []
end
