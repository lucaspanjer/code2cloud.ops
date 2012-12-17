define :c2c_user do
  name = params[:name]
  prefix = node[:c2c][:user_home_prefix]
  dir  = "#{prefix}/#{name}"

  group name

  user name do
    comment "Code2Cloud #{name}"
    gid name
    home dir
    shell "/bin/bash"
    supports :manage_home => true
  end

#  directory dir do
#    action :create
#    mode 0700
#    owner name
#    group name
#  end

end
