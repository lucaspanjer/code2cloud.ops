#!/usr/bin/ruby

chefDistro="target/c2c-ops-0.1.0-SNAPSHOT-local/chef/"
sshPort=2223

print "*** Syncing src with VM  ***\n"
system "rsync -avz --rsh='ssh -p#{sshPort} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' #{chefDistro} vcloud@localhost:/opt/code2cloud/chef/"


print "*** Starting chef run on VM ***\n"
goodChefRun = system "ssh -p#{sshPort} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vcloud@localhost /opt/code2cloud/chef/chef-solo.sh"
if goodChefRun
  print "**CHEF SUCCESS***\n"
else 
  print "**CHEF FAILURE***\n"
end