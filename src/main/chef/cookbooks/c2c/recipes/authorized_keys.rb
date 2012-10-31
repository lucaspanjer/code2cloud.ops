require 'etc'

node.c2c.authorized_keys.each do |config|
  begin
    Etc.getpwnam(config[:name])
    c2c_authorized_keys do
      username config[:name] 
      keys config[:keys]
    end
  rescue
    Chef::Log.warn("authorized_keys: user #{config[:name]} does not exist")
  end
end
