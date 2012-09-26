

#FIXME this does deployment regardless.
action :deploy do
  new_resource.artifacts.each do |artifact|
    root_package = "com.tasktop.c2c.server"
    package = "#{root_package}.#{artifact["package"]}"
  
    war = artifact["war"] || artifact["package"]
    if artifact["versioned"] != false
      war << "-" << node.cfc.server.version
    end
    war << ".war"
  
    source = war
  
    war = "#{artifact["name"]}.war"
    webapp_dir = artifact["webapp_dir"] || "#{node.tomcat.webapp_dir}"
    webapp = artifact["location"] || "#{webapp_dir}/#{war}"
    service = artifact["service"] || "tomcat"
    
    directory "exploded-#{war}" do
      path "#{webapp_dir}/#{artifact["name"]}"
      recursive true
      action :nothing
    end
  
    destWar = "#{webapp_dir}/#{war}"
    cookbook_file destWar do
      source source
      user node.tomcat.user
      group node.tomcat.group
      action :nothing
    end
    
    location = artifact["location"]
    if location
      cookbook_file location do
        source source
        action :nothing
      end
    end

    
    # FIXME this execute resource is a hack becaue I can't figure out how to notify from outside a resource.
    execute "Deploy" do
      command "echo Deploying #{war}"
      #getDeploymentArtifacts (nothing to do)
  
      unless artifact["location"] #skip deploy for hudson.war
        #preDeploy
        notifies :stop, resources(:service => "#{service}"), :immediately
  
        #doDeploy
        notifies :delete, resources(:directory => "exploded-#{war}"), :immediately
        notifies :create, resources(:cookbook_file => destWar), :immediately
  
        #postDeploy
        notifies :start, resources(:service => "#{service}"), :delayed  
      end
      if artifact["location"]
        notifies :create, resources(:cookbook_file => location), :immediately
      end
    end
  end
end