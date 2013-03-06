#!/bin/sh

sudo adduser vcloud
# follow prompts

sudo mkdir /opt/code2cloud
sudo chown vcloud:vcloud /opt/code2cloud

# this adds the "add-apt-repository" script
sudo apt-get install python-software-properties -y

# add Java JDK 7 from ppa
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer -y
# when prompted, choose "OK", then "Yes"

# set Java environment variables
sudo apt-get install oracle-java7-set-default -y

# install Apache2 web server
sudo apt-get install apache2 -y

# install Chef
echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list
sudo mkdir -p /etc/apt/trusted.gpg.d
gpg --fetch-key http://apt.opscode.com/packages@opscode.com.gpg.key
gpg --export packages@opscode.com | sudo tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null
sudo apt-get update
sudo apt-get install opscode-keyring -y
# when prompted, choose "Y"
sudo apt-get upgrade
# when prompted for the chef server url ... enter "none"
sudo apt-get install chef -y

# verify
java -version
sudo service apache2 status
