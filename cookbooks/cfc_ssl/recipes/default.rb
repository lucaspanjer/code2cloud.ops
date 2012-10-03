
hostname = cfc_role_address("profile")
baseDir = node.cfc.server.opt
pemFile = "#{baseDir}/etc/#{hostname}.ssl.pem"


# Get the certificate
execute "get cert from #{hostname}" do
  command "echo | openssl s_client -connect #{hostname}:443 2>&1 |sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > #{pemFile}"
end
# 

keystore = "#{node.java.java_home}/lib/security/jssecacerts"

# This will create the keystore if needed, and import our cert into it
execute "add cert to keystore" do
  command "/usr/java/jdk1.6.0_35/jre/bin/keytool -importcert -file #{pemFile} -keystore #{keystore} -storepass changeit <<EOF\nyes\nEOF"
  returns [0,1]
end
