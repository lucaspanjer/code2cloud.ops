#!/usr/bin/ruby

require 'fileutils'

st_hudson_homes='/home/code2cloud/hudson-homes'
mt_hudson_homes='/home/code2cloud/hudson'
destinationConfigDir = "#{mt_hudson_homes}/teams/" 

copyJobs=true # set to false to move instead (faster)

teamsHeader=<<EOF
<?xml version='1.0' encoding='UTF-8'?> 
<org.eclipse.hudson.security.team.TeamManager>
  <teams class="java.util.concurrent.CopyOnWriteArrayList"> 
EOF

teamsFooter=<<EOF
  </teams>
</org.eclipse.hudson.security.team.TeamManager>
EOF

teamFormater=<<EOF
    <org.eclipse.hudson.security.team.Team>
      <ownedJobNames class="java.util.concurrent.CopyOnWriteArrayList">
%s
      </ownedJobNames>
      <teamName>%s</teamName>
    </org.eclipse.hudson.security.team.Team>
EOF

system "sudo service tomcat6 stop"

teamConfig = teamsHeader

Dir.glob("#{st_hudson_homes}/*") do |proj_dir|
  puts "Processing #{proj_dir}"
  projectId = proj_dir.match(/#{st_hudson_homes}\/(.*)/i).captures[0]
  puts "  projectId: #{projectId}"
  jobsString = ""
  
  destinationJobsDir = "#{mt_hudson_homes}/teams/#{projectId}/jobs/" 
  FileUtils.mkpath destinationJobsDir unless File.exists?(destinationJobsDir)
  
  Dir.glob("#{proj_dir}/jobs/*") do |job_dir|
    jobName = job_dir.match(/#{proj_dir}\/jobs\/(.*)/i).captures[0]
    puts "   job: #{jobName}"
    jobId="#{projectId}_#{jobName}"
    # Add to team config
    if ! jobsString.empty?
      jobsString = jobsString + "\n"
    end
    jobsString = jobsString + "       <string>#{jobId}</string>"

    
    # Move jobs to new dir
    if copyJobs
      FileUtils.cp_r(job_dir, "#{destinationJobsDir}/#{jobName}")
    else
      FileUtils.mv(job_dir, "#{destinationJobsDir}/#{jobName}")
    end
    puts "#{copyJobs ? "Copied" : "Moved"} job to #{destinationJobsDir}"
    
    # Add id property to the job config
    configXmlFile = "#{destinationJobsDir}/#{jobName}/config.xml"
    configXml = File.read(configXmlFile)
    migratedConfigXml = configXml.sub("<project>", "<project>\n  <id>#{jobId}</id>") 
    File.open(configXmlFile, 'w') {|f| f.write(migratedConfigXml)}
    
    
  end
  thisTeamConfig = teamFormater % [jobsString, projectId]
  teamConfig = teamConfig + thisTeamConfig
end

teamConfig = teamConfig + teamsFooter

FileUtils.mkpath destinationConfigDir unless File.exists?(destinationConfigDir)
configFile = File.new("#{destinationConfigDir}/teams.xml", "w")
configFile.write(teamConfig)
configFile.close
puts "Team config written to #{configFile.path}"

puts "Ensuring tomcat permissions on #{mt_hudson_homes}"
system "sudo chown -R tomcat6 #{mt_hudson_homes}"
puts "Removing webapps"
system "sudo rm -rf /opt/code2cloud/webapps/s#* /opt/code2cloud/webapps/hudson-config*"
