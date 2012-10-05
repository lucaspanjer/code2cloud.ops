directory node.grails.root_dir do
  action :create
  owner node.grails.user
  mode 0755
end

package "unzip"

remote_file "#{node.grails.root_dir}/#{node.grails.package}" do
  source node.grails.url
  action :create_if_missing
  mode 0644
end

execute "unzip #{node.grails.package}" do
  cwd node.grails.root_dir
  user node.grails.user
  not_if { File.exists?(node.grails.bin) }
end

template "/usr/bin/grails" do
  source "grails.erb"
  mode 0755
end

execute "grails --help" do
  user node.grails.user
end
