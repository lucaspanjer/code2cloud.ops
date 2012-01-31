require 'etc'

define :cfc_authorized_keys, :cookbook => nil, :dir => nil, :keys => nil do

  name = params[:name]
  dir = params[:dir] || node[:cfc][:authorized_keys_dir]

  if dir
    dotssh = "#{dir}/#{name}"
  else
    pwent = Etc.getpwnam(name)
    dotssh = "#{pwent.dir}/.ssh"
  end

  directory dotssh do
    action :create
    mode 0700
    owner name
  end

  if params[:keys]
    file "#{dotssh}/authorized_keys" do
      owner name
      mode 0600
      content params[:keys].join("\n")
    end
  else
    cookbook_file "#{dotssh}/authorized_keys" do
      action :create
      owner name
      mode 0600
      source "authorized_keys.#{name}"
      backup false
      cookbook params[:cookbook]
    end
  end
end
