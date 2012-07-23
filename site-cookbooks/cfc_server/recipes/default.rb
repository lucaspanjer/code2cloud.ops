#base recipe for hmaster, hub, scm and task


# FIXME, not sure why this is needed
#cfc_user node.tomcat.user

include_recipe "tomcat::default"
include_recipe "etchosts::default"
include_recipe "ntp"


if node.cfc.server.backup.enabled
  package "duplicity"
  package "python-boto" # for duplicity over s3
  package "ssmtp" # For smtp over gmail
end

directory node.cfc.server.home do
  owner node.cfc.user
  group node.cfc.group
  mode 0771
  recursive true
end

directory node.cfc.server.opt do
  owner node.cfc.user
  group node.cfc.group
  mode 0771
  recursive true
end

node.cfc.server.opt_sym_links.each do |opt_link|
  link opt_link do
    to node.cfc.server.opt
    owner node.cfc.user
    group node.tomcat.group
  end
end

  
link "#{node.cfc.server.opt}/webapps" do
  to node.tomcat.webapp_dir
  owner node.cfc.user
  group node.tomcat.group
end

link "#{node.cfc.server.opt}/tc_logs" do
  to node.tomcat.log_dir
  owner node.cfc.user
  group node.cfc.group
end


execute "usermod -a -G #{node.tomcat.user} #{node.cfc.user}" do
   # FIXME NOT IF ??
end

execute "usermod -a -G adm #{node.cfc.user}" do
   # FIXME NOT IF ??
end

execute "usermod -a -G #{node.cfc.user} #{node.tomcat.user}" do
   # FIXME NOT IF ??
end

directory "#{node.cfc.server.opt}/etc/" do
  owner node.cfc.user
  group node.cfc.group
  recursive true
  action :create
end

template "#{node.cfc.server.opt}/etc/log4j.xml" do
  source "log4j.xml.erb"
  owner node.cfc.user
  group node.tomcat.group
  mode 0660
end

directory "#{node.cfc.server.opt}/bin" do
  owner node.cfc.user
  group node.cfc.group
  recursive true
end

if node.cfc.server.backup.enabled

  template "#{node.cfc.server.opt}/bin/backup-dirs.pl" do
    source "backup-dirs.pl.erb"
    owner node.cfc.user
    group node.cfc.user
    mode 0770
  end
  
  template "/etc/ssmtp/ssmtp.conf" do
    source "ssmtp.conf.erb"
    mode 0774
  end
  
  template "/etc/ssmtp/revaliases" do
    source "revaliases.erb"
    mode 0774
  end
  
  
  cron "backup-dirs" do
    hour "1"
    minute "0"
    command "#{node.cfc.server.opt}/bin/backup-dirs.pl"
    user node.cfc.user
    mailto node.cfc.admin_email
  end

  cookbook_file "#{node.cfc.server.opt}/etc/backup_pubkey.txt" do
    source "backup_pubkey.txt"
    owner node.cfc.user
    group node.cfc.user
  end
  
  execute "gpg: import" do
    not_if "sudo -u #{node.cfc.user} gpg --list-keys #{node.cfc.server.backup.key_name}"
    #FIXME should use a property for this sig                                                                                                      
    command "gpg --import #{node.cfc.server.opt}/etc/backup_pubkey.txt && echo D18422C06DA0E931CBEBE73C99F305CB48F1289B:6: | gpg --import-ownertru\
  st"
    user node.cfc.user
    action :run
  end
end

cookbook_file "/etc/security/limits.conf" do
  mode 0644
end

cookbook_file "/etc/pam.d/common-session" do
  mode 0644
end


if node.cfc.server.build
  artifacts = node.cfc.server.artifacts
else
  artifacts = []
end

template "/etc/environment" do
  source "environment.erb"
  mode 0644
end



