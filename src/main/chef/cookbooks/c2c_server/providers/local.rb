

#FIXME this does deployment regardless.
action :deploy do
  if !node.c2c.server.build
    Chef::Log.warn("No build selected. Not deploying artifacts.")
  else
  new_resource.artifacts.each do |artifact|
    root_package = "com.tasktop.c2c.server"
    package = "#{root_package}.#{artifact["package"]}"
  
    war = artifact["war"] || artifact["package"]
    if artifact["versioned"] != false
      war << "-" << node.c2c.server.version
    end
    war << ".war"
  
    source = [ node.c2c.server.home, "hudson-homes/c2c/jobs", node.c2c.server.job, "builds", node.c2c.server.build,
               "archive", root_package, package, "target", war ].join("/")
  
    war = "#{artifact["name"]}.war"
    webapp_dir = artifact["webapp_dir"] || "#{node.tomcat.webapp_dir}"
    webapp = artifact["location"] || "#{webapp_dir}/#{war}"
    service = artifact["service"] || "tomcat"
    
    directory "exploded-#{war}" do
      path "#{webapp_dir}/#{artifact["name"]}"
      recursive true
      action :nothing
    end
  
    execute "deploy-#{war}" do
      command "cp  #{source} #{webapp_dir}/#{war}"
      # For some reason this will break (permissions issue), but works when I try to run manually as tomcat6. 
      # This way still presevers proper owner/gropu
      #user node.tomcat.user
      #group node.tomcat.group
      action :nothing
    end
    
    location = artifact["location"]
    execute "cp-#{war}" do
      command "cp  #{source} #{location}"
      action :nothing
    end

    
    #FIXME do an if modified check
    # FIXME this execute resource is a hack becaue I can't figure out how to notify from outside a resource.
    execute "Deploy  #{war}" do
      command "echo Deploying #{war}"
      #getDeploymentArtifacts (nothing to do)
  
      unless artifact["location"] #skip deploy for hudson.war
        #preDeploy
        notifies :stop, resources(:service => "#{service}"), :immediately
  
        #doDeploy
        notifies :delete, resources(:directory => "exploded-#{war}"), :immediately
        notifies :run, resources(:execute => "deploy-#{war}"), :immediately
  
        #postDeploy
        notifies :start, resources(:service => "#{service}"), :delayed  
      end
      if artifact["location"]
        notifies :run, resources(:execute => "cp-#{war}"), :immediately
      end
    end
  end
  end
end