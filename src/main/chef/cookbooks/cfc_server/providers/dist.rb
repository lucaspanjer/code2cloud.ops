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

      needService = false
      if artifact["location"]
        dest = artifact["location"]
      else
        needService=true
        dest = "#{webapp_dir}/#{war}"
      end
      
      sourceMd5=`md5sum #{source}`.split(' ')[0] # FIXME get before space
      destMd5=`md5sum #{dest}`.split(' ')[0]
      
      if sourceMd5 == destMd5
        Chef::Log.warn("#{source} and #{dest} same, skipping deploy")
        next
      end 

      if needService
        directory "exploded-#{war}" do
          path "#{webapp_dir}/#{artifact["name"]}"
          recursive true
          action :nothing
        end
      end

      execute "cp to #{dest}" do
        command "cp #{source} #{dest} && chown #{node.tomcat.user}:#{node.tomcat.user} #{dest}"
        action :nothing
      end

      # NOTE this execute resource is used to notify other resources inside.
      execute "Deploy #{war}" do
        command "echo Deploying #{war}"
        if needService
          #preDeploy
          notifies :stop, resources(:service => "#{service}"), :immediately
          #doDeploy
          notifies :delete, resources(:directory => "exploded-#{war}"), :immediately
          #postDeploy
          notifies :start, resources(:service => "#{service}"), :delayed
        end
        #doDeploy
        notifies :run, resources(:execute => "cp to #{dest}"), :immediately

      end
    end
  end
end