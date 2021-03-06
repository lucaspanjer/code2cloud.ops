#c2c_user node.c2c.dmz.user

include_recipe "apache2"

modules = %w(alias auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex
cgid deflate dir env mime negotiation proxy_http proxy reqtimeout rewrite setenvif status)

modules.each do |name|
  apache_module name
end

if platform?("oracle")
  include_recipe "apache2::mod_ssl"
end

apache_module "ssl"

#disable the default site
apache_site "000-default" do
  enable false
end

site = "site-normal"

if platform?("oracle")
  cert_dir="/etc/httpd/certs"
  log_dir="/var/log/httpd/"
else
  cert_dir="/etc/apache2/certs"
  log_dir="/var/log/apache2/"
end

template "#{node.apache.dir}/sites-available/#{site}" do
  source "site-normal.erb"
  mode 0644
  variables :prefix => (node.c2c[:hub] ? (node.c2c.hub.prefix_path+"/") : "/"), 
    :port => node.c2c.hub.has_internal_services ? "8081" : "8080",
    :cert_dir => cert_dir,
    :log_dir => log_dir
end

apache_site site do
  enable true
end

cert_hostname = c2c_role_address("profile")
if (node.c2c.hub.wildcard_dns)
  cert_hostname = "*."+cert_hostname
end
directory cert_dir do
  owner node.c2c.local_apache.user
  group node.c2c.local_apache.user
  mode 0755
end
cert_file="#{cert_dir}/self.crt"
key_file="#{cert_dir}/self.key"
unless File.exists?(cert_file)
  execute "create self-signed cert" do
    command "openssl req -new -x509 -nodes -days 3000 -out #{cert_file} -keyout #{key_file} -subj '/C=US/ST=California/L=San Francisco/CN=#{cert_hostname}'"
  end
end