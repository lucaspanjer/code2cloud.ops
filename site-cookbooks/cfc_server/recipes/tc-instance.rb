directory "#{node.cfc.tomcat.instance_base}" do
  owner node.tomcat.user
  group node.tomcat.group
  mode "0775"
  action :create
end


%w(webapps logs work conf shared server common).each do |name|
  directory "#{node.cfc.tomcat.instance_base}/#{name}" do
    owner node.tomcat.user
    group node.tomcat.group
    mode "0775"
    action :create
  end
end


execute "copy config" do
  command "cp -r -L #{node.tomcat.base}/conf/* #{node.cfc.tomcat.instance_base}/conf"
  user node.tomcat.user
  group node.tomcat.group
end

template "#{node.cfc.tomcat.instance_base}/conf/server.xml" do
  source "server.xml.erb"
  owner node.tomcat.user
  group node.tomcat.group
  mode "0644"
  #notifies :restart, resources(:service => "tomcat")
end

if  (platform?("oracleserver", "oracle"))
  template "/etc/init.d/#{node.cfc.tomcat.instance_name}" do
        source "service.oracle.erb"
        mode "0755"
      end 
      
  template "#{node.cfc.tomcat.instance_base}/conf/tomcat6.conf" do
    source "default_tomcat6.erb"
    owner node.tomcat.user
    group node.tomcat.group
    mode "0644"
    #notifies :restart, resources(:service => "tomcat")
  end
else
  template "/etc/init.d/#{node.cfc.tomcat.instance_name}" do
      source "service.erb"
      mode "0755"
    end 
    
  template "#{node.cfc.tomcat.instance_base}/default" do
    source "default_tomcat6.erb"
    owner node.tomcat.user
    group node.tomcat.group
    mode "0644"
    #notifies :restart, resources(:service => "tomcat")
  end
end

service node.cfc.tomcat.instance_name do
  supports :status => true, :restart => true
  action :enable
end