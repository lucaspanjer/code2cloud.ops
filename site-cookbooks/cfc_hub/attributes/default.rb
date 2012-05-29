default[:cfc][:service] = "hub"
default[:cfc][:github][:consumer_key] = nil
default[:cfc][:github][:consumer_secret] = nil
default[:cfc][:hub][:prefix_path] = ""
default[:cfc][:hub][:protocol] = "https"
default[:cfc][:hub][:invitation_only] = true
default[:cfc][:hub][:public_ssh_port] = 2222
default[:cfc][:hub][:internal_ssh_port] = 2222
default[:cfc][:hub][:service_proxy_path] = nil
default[:cfc][:hub][:remember_me_key] = "XXX"
default[:cfc][:hub][:has_internal_services] = false
  # FIXME will not work
if attribute?("cfc.hub.has_internal_services")
  override[:cfc][:tomcat][:instance_name] = "hub-tomcat"
end
default[:cfc][:hub][:jdbc_type] = "mysql"




