hostname = cfc_role_address("profile")
baseDir = node.cfc.server.opt
pemFile = "#{baseDir}/etc/#{hostname}.ssl.pem"

directory "#{node.cfc.server.opt}/etc" do
  owner node.cfc.user
  group node.cfc.group
  mode 0771
  recursive true
end

# Get the certificate
execute "get cert from #{hostname}" do
  command "echo | openssl s_client -connect #{hostname}:443 2>&1 |sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > #{pemFile}"
end
#

keystore = "#{node.java.java_home}/lib/security/jssecacerts"

# This will create the keystore if needed, and import our cert into it
execute "add cert to keystore" do
  command "#{node.java.java_home}/bin/keytool -importcert -file #{pemFile} -keystore #{keystore} -storepass changeit <<EOF\nyes\nEOF"
  returns [0,1]
end

certs_file = "/etc/ssl/certs/ca-bundle.crt"

# append to /etc/ssl/certs/ca-bundle.crt if needed.
# FIXME better way of determining if in there already?
ruby_block "ensure ssl in #{certs_file}" do
  block do
    file = File.open(pemFile, "r")
    pemContents = file.read
    file.close

    file = File.open(certs_file, "r")
    certsContents = file.read

    unless certsContents.include? pemContents
      `cat #{pemFile} >> #{certs_file}`
    end
  end
end
