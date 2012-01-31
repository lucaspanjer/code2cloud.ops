require 'etc'

node.cfc.authorized_keys.each do |name|
  begin
    Etc.getpwnam(name)
    cfc_authorized_keys name
  rescue
    Chef::Log.warn("authorized_keys: user #{name} does not exist")
  end
end
