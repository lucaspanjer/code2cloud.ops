define :cfc_user do
  name = params[:name]
  dir  = "/home/#{name}"

  group name

  user name do
    comment "Cloud2Code #{name}"
    gid name
    home dir
    shell "/bin/bash"
  end

  directory dir do
    action :create
    mode 0700
    owner name
    group name
  end

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
