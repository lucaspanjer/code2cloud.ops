define :c2c_log4j_config do

  type = params[:name]

  template "#{node.c2c.server.opt}/etc/log4j-#{type}.xml" do
    source "log4j.xml.erb"
    cookbook "c2c_server"
    owner node.c2c.user
    group node.tomcat.group
    mode 0660
    variables({
      :type => "#{type}"
    })
  end
end
