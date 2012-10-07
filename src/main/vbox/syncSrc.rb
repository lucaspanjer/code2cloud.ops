#!/usr/bin/ruby

$vmTemplate="CloudDevLocal"
chefDistro="target/clouddev-ops-0.1.0-SNAPSHOT-local.tar.gz"
sshPort=2222
$vbox="VBoxManage"
srcDir="src/main/chef/"

print "*** Syncing src with VM  ***\n"
system "rsync -avz --rsh='ssh -p#{sshPort}' #{srcDir} vcloud@localhost:/opt/code2cloud/chef/"



