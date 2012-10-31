#c2c_user node.c2c.dmz.user

include_recipe "apache2"

file "#{node.apache.dir}/mods-available/proxy.conf" do
  content "#Proxy configuration is in #{node.apache.dir}/sites-available/#{node.c2c.dmz.servername}-normal"
  notifies :restart, "service[apache2]"
end

modules = %w(alias auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex
             cgid deflate dir env mime negotiation proxy_http proxy reqtimeout rewrite setenvif status)

modules.each do |name|
  apache_module name
end

if node.c2c.dmz.ssl
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

cookbook_file "#{node.apache.dir}/conf.d/c2c_dmz.conf" do
  source "c2c_dmz.conf"
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
  site = "#{node.c2c.dmz.servername}-#{mode}"

  template "#{node.apache.dir}/sites-available/#{site}" do
    source "site-#{mode}.erb"
    mode 0644
    variables :prefix => node.c2c[:hub] ? (node.c2c.hub.prefix_path+"/") : "/"
  end

  apache_site site do
    enable node.c2c.dmz.mode == mode
  end
end

directory node.c2c.dmz.home do
  owner node.c2c.dmz.user
  group node.c2c.dmz.user
  mode 0755
end

www_root = "#{node.c2c.dmz.home}/www-root"
directory www_root do
  owner node.c2c.dmz.user
  group node.c2c.dmz.user
  mode 0755
end

template "#{node.c2c.user_home}/.netrc" do
  source "netrc.erb"
  owner node.c2c.user
  group node.c2c.user
  mode 0600
end

#hack to make sure libcurl parses the correct .netrc
process_home = ENV['HOME']
ruby_block "adjust HOME" do
  block { ENV['HOME'] = "#{node.c2c.user_home}" }
end

=begin

git_clone = File.join(node.c2c.dmz.home, File.basename(node.c2c.dmz.git_repo))

git git_clone do
  repository node.c2c.dmz.git_repo
  revision "master"
  action :sync
  user node.c2c.dmz.user
  group node.c2c.dmz.user
end

ruby_block "reset HOME" do
  block { ENV['HOME'] = process_home }
end

["maintenance", "coming-soon"].each do |dir|
  execute "rsync -ar #{git_clone}/#{dir} #{node.c2c.dmz.home}"
  user node.c2c.dmz.user
  group node.c2c.dmz.user
end

[404, 500].each do |file|
  execute "rsync -a #{git_clone}/maintenance/#{file}.html #{www_root}"
  user node.c2c.dmz.user
  group node.c2c.dmz.user
end

package "unzip"

site_url = "#{c2c_hudson_url}/job/Eclipse-Client-Main/lastSuccessfulBuild/artifact/com.tasktop.c2c.client-site/target/site"

bash "unzip" do
  user node.c2c.dmz.user
  group node.c2c.dmz.user
  cwd www_root
  code "unzip site.zip && rm -rf updateSite/ && mv site updateSite"
  action :nothing
end

remote_file "site.zip" do
  source "#{site_url}/*zip*/site.zip"
  path "#{www_root}/site.zip"
  owner node.c2c.dmz.user
  group node.c2c.dmz.user
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