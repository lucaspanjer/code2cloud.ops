

#example of how artifacts can be deployed
#not gonna fly atm as there are some manual steps in between
action :deploy do
  if !node.cfc.server.build
    Chef::Log.warn("No build selected. Not deploying artifacts.")
  else
  new_resource.artifacts.each do |artifact|
    root_package = "com.tasktop.c2c.server"
    package = "#{root_package}.#{artifact["package"]}"
  
    war = artifact["war"] || artifact["package"]
    if artifact["versioned"] != false
      war << "-" << node.cfc.server.version
    end
    war << ".war"
  
    remote = [ cfc_hudson_url, "job", node.cfc.server.job, node.cfc.server.build,
               "artifact", root_package, package, "target", war ].join("/")
  
    local = artifact["location"] || "#{node.cfc.server.home}/#{artifact["name"]}.war"
    war = "#{artifact["name"]}.war"
    webapp_dir = artifact["webapp_dir"] || "#{node.tomcat.webapp_dir}"
    webapp = artifact["location"] || "#{webapp_dir}/#{war}"
    service = artifact["service"] || "tomcat"
  
    remote_file "download-#{war}" do
      path local
      source remote
      mode "0770"
      owner node.tomcat.user
      group node.tomcat.group
      action "nothing"
    end
  
    directory "exploded-#{war}" do
      path "#{webapp_dir}/#{artifact["name"]}"
      recursive true
      action :nothing
    end
  
    execute "deploy-#{war}" do
      command "mv  #{local} #{webapp_dir}"
      # For some reason this will break (permissions issue), but works when I try to run manually as tomcat6. 
      # This way still presevers proper owner/gropu
      #user node.tomcat.user
      #group node.tomcat.group
      action :nothing
    end
    
    location = artifact["location"]
      execute "cp-#{war}" do
        command "mv  #{local} #{location}"
        action :nothing
      end

  
    http_request "HEAD #{war}" do
      message ""
      url remote
      action :head
      if ::File.exists?(webapp)
        headers "If-Modified-Since" => ::File.mtime(webapp).httpdate
      end
  
      #getDeploymentArtifacts
      notifies :create, resources(:remote_file => "download-#{war}"), :immediately
  
      unless artifact["location"] #skip deploy for hudson.war
        #preDeploy
        notifies :stop, resources(:service => "#{service}"), :immediately
  
        #doDeploy
        notifies :delete, resources(:directory => "exploded-#{war}"), :immediately
        notifies :run, resources(:execute => "deploy-#{war}"), :immediately
  
        #postDeploy
        notifies :start, resources(:service => "#{service}"), :delayed  
      end
    end
  end
  end
end