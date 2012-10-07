#!/usr/bin/ruby

$vmTemplate="CloudDevLocal"
chefDistro="target/clouddev-ops-0.1.0-SNAPSHOT-local.tar.gz"
sshPort=2222
$vbox="VBoxManage"
extractedRepo="target/clouddev-ops-0.1.0-SNAPSHOT-local/"

def isRunning()
  state = ""
  `#{$vbox} showvminfo #{$vmTemplate}`.each {|line|
    if line.start_with? "State:"
      print line;
      state = line
      break
    end
  }
  if state.include? "running"
    return true else return false
  end
end

if isRunning
  print "*** VM is running\n"
  # TODO clone in this case?
else
  print "*** Starting VM\n"
  system "#{$vbox} startvm #{$vmTemplate} && echo sleeping... && sleep 60"
end


if File.exist? extractedRepo
  print "*** #{extractedRepo} exists, skipping local extraction ***\n"
else
  print "*** extracting to #{extractedRepo} ***\n"
  system "mkdir #{extractedRepo} && tar xzvf #{chefDistro} -C #{extractedRepo}"
end

print "*** Syncing chef distro ***\n"
system "rsync -avz --rsh='ssh -p#{sshPort}' #{extractedRepo} vcloud@localhost:/opt/code2cloud/"

print "*** Starting chef run on VM ***\n"
goodChefRun = system "ssh -p#{sshPort} vcloud@localhost /opt/code2cloud/chef/chef-solo.sh"
if goodChefRun
  print "**CHEF SUCCESS***\n"
else 
  print "**CHEF FAILURE***\n"
end


