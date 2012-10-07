action :deploy do
  if !node.cfc.server.deploy
    Chef::Log.warn("Skipping deploying artifacts")
  else
    new_resource.artifacts.each do |artifact|
      root_package = "com.tasktop.c2c.server"
      package = "#{root_package}.#{artifact["package"]}"

      war = artifact["war"] || artifact["package"]
      if artifact["versioned"] != false
        war << "-" << node.cfc.server.version
      end
      war << ".war"

      source = "/opt/code2cloud/chef/"+war
      
      if !::File.exist? source
        Chef::Log.warn("#{source} not found, skipping deploy")
        next
      end
      
      war = "#{artifact["name"]}.war"
      webapp_dir = artifact["webapp_dir"] || "#{node.tomcat.webapp_dir}"
      webapp = artifact["location"] || "#{webapp_dir}/#{war}"
      service = artifact["service"] || "tomcat"

      # TODO : reorg to get combine local/war deploy, cp not move, check md5 between source and dest 
      # 
        
      directory "exploded-#{war}" do
        path "#{webapp_dir}/#{artifact["name"]}"
        recursive true
        action :nothing
      end

      destWar = "#{webapp_dir}/#{war}"

      execute "mv to #{destWar}" do
        command "mv #{source} #{destWar} && chown #{node.tomcat.user}:#{node.tomcat.user} #{destWar}"
        action :nothing
      end

      location = artifact["location"]
      if location
        execute location do
          command "mv #{source} #{location} && chown #{node.tomcat.user}:#{node.tomcat.user} #{location}"
          action :nothing
        end
      end

      # NOTE this execute resource is used to notify other resources inside.
      execute "Deploy #{war}" do
        command "echo Deploying #{war}"
        #getDeploymentArtifacts (nothing to do)

        unless artifact["location"] #skip deploy for hudson.war
          #preDeploy
          notifies :stop, resources(:service => "#{service}"), :immediately

          #doDeploy
          notifies :delete, resources(:directory => "exploded-#{war}"), :immediately
          notifies :run, resources(:execute => "mv to #{destWar}"), :immediately

          #postDeploy
          notifies :start, resources(:service => "#{service}"), :delayed
        end
        if artifact["location"]
          notifies :run, resources(:execute => location), :immediately
        end
      end
    end
  end
end