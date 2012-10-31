

#example of how artifacts can be deployed
#not gonna fly atm as there are some manual steps in between
action :deploy do
  if !node.c2c.server.build
    Chef::Log.warn("No build selected. Not deploying artifacts.")
  else
  new_resource.artifacts.each do |artifact|
    root_dir = node.c2c.server.root_dir || "com.tasktop.c2c.server"
    root_package = node.c2c.server.root_package || "com.tasktop.c2c.server"
    package = "#{root_package}.#{artifact["package"]}"
  
    war = artifact["war"] || artifact["package"]
    if artifact["versioned"] != false
      war << "-" << node.c2c.server.version
    end
    war << ".war"
  
    remote = [ c2c_hudson_url, "job", node.c2c.server.job, node.c2c.server.build,
               "artifact", root_dir, package, "target", war ].join("/")
  
    local = artifact["location"] || "#{node.c2c.server.home}/#{artifact["name"]}.war"
    war = "#{artifact["name"]}.war"
    webapp_dir = artifact["webapp_dir"] || "#{node.tomcat.webapp_dir}"
    service = artifact["service"] || "tomcat"
  
  
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

    remote_file "download-#{war}" do
         path local
         source remote
         mode "0770"
         owner node.tomcat.user
         group node.tomcat.group
         action :nothing
      end
      
   Chef::Log.info("Deploying from [#{remote}] to [#{webapp_dir}/#{war}]")
   
         # FIXME this execute resource is a hack becaue I can't figure out how to notify from outside a resource.
       execute "Deploy-#{war}" do
         command "echo Deploying #{war}"
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