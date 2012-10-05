#cfc_user node.cfc.dmz.user

include_recipe "apache2"

file "#{node.apache.dir}/mods-available/proxy.conf" do
  content "#Proxy configuration is in #{node.apache.dir}/sites-available/#{node.cfc.dmz.servername}-normal"
  notifies :restart, "service[apache2]"
end

modules = %w(alias auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex
             cgid deflate dir env mime negotiation proxy_http proxy reqtimeout rewrite setenvif status)

modules.each do |name|
  apache_module name
end

if node.cfc.dmz.ssl
  if platform?("oracle")
    include_recipe "apache2::mod_ssl"
  end
  
  apache_module "ssl"
  
  template "#{node.apache.dir}/certs/go_daddy_bundle.crt" do
    source "go_daddy_bundle.crt.erb"
    notifies :restart, "service[apache2]"
  end
  
  template "#{node.apache.dir}/certs/wildcard.tasktop.com.crt" do
    source "wildcard.tasktop.com.crt.erb"
    notifies :restart, "service[apache2]"
  end
  
  template "#{node.apache.dir}/certs/wildcard.tasktop.com.key" do
    source "wildcard.tasktop.com.key.erb"
    notifies :restart, "service[apache2]"
  end
end

cookbook_file "#{node.apache.dir}/conf.d/cfc_dmz.conf" do
  source "cfc_dmz.conf"
  notifies :restart, "service[apache2]"
end

directory "#{node.apache.dir}/certs" do
  owner node.apache.user
  group node.apache.user
  recursive true
end

#disable the default site
apache_site "000-default" do
  enable false
end

%w(normal maintenance).each do |mode|
  site = "#{node.cfc.dmz.servername}-#{mode}"

  template "#{node.apache.dir}/sites-available/#{site}" do
    source "site-#{mode}.erb"
    mode 0644
    variables :prefix => node.cfc[:hub] ? (node.cfc.hub.prefix_path+"/") : "/"
  end

  apache_site site do
    enable node.cfc.dmz.mode == mode
  end
end

directory node.cfc.dmz.home do
  owner node.cfc.dmz.user
  group node.cfc.dmz.user
  mode 0755
end

www_root = "#{node.cfc.dmz.home}/www-root"
directory www_root do
  owner node.cfc.dmz.user
  group node.cfc.dmz.user
  mode 0755
end

template "#{node.cfc.user_home}/.netrc" do
  source "netrc.erb"
  owner node.cfc.user
  group node.cfc.user
  mode 0600
end

#hack to make sure libcurl parses the correct .netrc
process_home = ENV['HOME']
ruby_block "adjust HOME" do
  block { ENV['HOME'] = "#{node.cfc.user_home}" }
end

=begin

git_clone = File.join(node.cfc.dmz.home, File.basename(node.cfc.dmz.git_repo))

git git_clone do
  repository node.cfc.dmz.git_repo
  revision "master"
  action :sync
  user node.cfc.dmz.user
  group node.cfc.dmz.user
end

ruby_block "reset HOME" do
  block { ENV['HOME'] = process_home }
end

["maintenance", "coming-soon"].each do |dir|
  execute "rsync -ar #{git_clone}/#{dir} #{node.cfc.dmz.home}"
  user node.cfc.dmz.user
  group node.cfc.dmz.user
end

[404, 500].each do |file|
  execute "rsync -a #{git_clone}/maintenance/#{file}.html #{www_root}"
  user node.cfc.dmz.user
  group node.cfc.dmz.user
end

package "unzip"

site_url = "#{cfc_hudson_url}/job/Eclipse-Client-Main/lastSuccessfulBuild/artifact/com.tasktop.c2c.client-site/target/site"

bash "unzip" do
  user node.cfc.dmz.user
  group node.cfc.dmz.user
  cwd www_root
  code "unzip site.zip && rm -rf updateSite/ && mv site updateSite"
  action :nothing
end

remote_file "site.zip" do
  source "#{site_url}/*zip*/site.zip"
  path "#{www_root}/site.zip"
  owner node.cfc.dmz.user
  group node.cfc.dmz.user
  mode 0644
  action :nothing
  notifies :run, "bash[unzip]", :immediately
end

site_xml = "#{www_root}/updateSite/site.xml"
http_request "HEAD site.xml" do
  message ""
  url "#{site_url}/site.xml"
  action :head
  if ::File.exists?(site_xml)
    headers "If-Modified-Since" => ::File.mtime(site_xml).httpdate
  end

  notifies :create, "remote_file[site.zip]", :immediately
end
=end