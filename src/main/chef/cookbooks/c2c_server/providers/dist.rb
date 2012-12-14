# Deploy artifacts from the /opt/code2cloud/chef directory
# Keys:
#  * war :
#  * versioned :
#  * service : the service to stop/start before/after deploy (defaults to tomcat)
#  * location : the location to deploy too (defaults to
#  * script : the location of a deployScript to be run after copying artifacts, but before starting service
action :deploy do
  if !node.c2c.server.deploy
    Chef::Log.warn("Skipping deploying artifacts")
  else
    new_resource.artifacts.each do |artifact|
      root_package = "com.tasktop.c2c.server"
      package = "#{root_package}.#{artifact["package"]}"

      war = artifact["war"] || artifact["package"]
      if artifact["versioned"] != false
        war << "-" << node.c2c.server.version
      end
      war << ".war"

      source = "/opt/code2cloud/chef/"+war

      if !::File.exist? source
        Chef::Log.warn("#{source} not found, skipping deploy")
        next
      end

      war = "#{artifact["name"]}.war"
      webapp_dir = artifact["webapp_dir"] || "#{node.tomcat.webapp_dir}"
      dest = artifact["location"] || "#{webapp_dir}/#{war}"
      service = artifact["service"] || "tomcat"

      needService = false
      needDelete = true
      needScriptRun = false

      if artifact["location"]
        needDelete = false
      else
        needService=true
      end
      

      sourceMd5=`md5sum #{source}`.split(' ')[0]
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
      
      if artifact["script"]
        script = artifact["script"]
        needScriptRun = true
        execute "script" do
          command script
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
        #preDeploy
        if needService
          notifies :stop, resources(:service => "#{service}"), :immediately
        end

        #doDeploy
        if needDelete
          notifies :delete, resources(:directory => "exploded-#{war}"), :immediately
        end
        notifies :run, resources(:execute => "cp to #{dest}"), :immediately

        #postDeploy
        if  needScriptRun
          notifies :run, resources(:execute => "script"), :immediately
        end
        
        if needService
          notifies :start, resources(:service => "#{service}"), :delayed
        end
      end

    end
  end
end