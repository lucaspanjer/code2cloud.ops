#entries = node[:etchosts][:entries] #|| search(:node, "*:*").collect { |node|
#  { :hostname => node[:hostname], :fqdn => node[:fqdn], :ipaddress => node[:ipaddress] }
#}

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode "0644"

#  variables(:entries => entries)
end
