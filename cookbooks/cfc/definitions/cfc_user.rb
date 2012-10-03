define :cfc_user do
  name = params[:name]
  prefix = node[:cfc][:user_home_prefix]
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

  if node[:cfc][:artifacts]
    #generate .wgetrc
    wgetrc = []

    %w(http_user http_password http_proxy https_proxy).each do |key|
      next unless val = node[:cfc][:artifacts][key.to_sym]
      wgetrc << "#{key} = #{val}"
    end

    file "#{dir}/.wgetrc" do
      content wgetrc.join("\n")
      mode 0400
      owner name
      group name
    end
  end
end
