default[:c2c][:service] = "hub"
default[:c2c][:github][:consumer_key] = nil
default[:c2c][:github][:consumer_secret] = nil
default[:c2c][:hub][:prefix_path] = ""
default[:c2c][:hub][:protocol] = "https"
default[:c2c][:hub][:wildcard_dns] = false
default[:c2c][:hub][:invitation_only] = true
default[:c2c][:hub][:public_ssh_port] = 2222
default[:c2c][:hub][:internal_ssh_port] = 2222
default[:c2c][:hub][:service_proxy_path] = nil
default[:c2c][:hub][:remember_me_key] = "XXX"
default[:c2c][:hub][:has_internal_services] = false
default[:c2c][:hub][:jdbc_path] = "/profile"
default[:c2c][:hub][:additional_properties] = []
  # FIXME will not work
if attribute?("c2c.hub.has_internal_services")
  override[:c2c][:tomcat][:instance_name] = "hub-tomcat"
end





