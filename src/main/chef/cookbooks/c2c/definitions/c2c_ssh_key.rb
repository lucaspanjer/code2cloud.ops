#generate ssh private key and save .pub key for other node's authorized_keys
define :c2c_ssh_key, :type => "rsa", :mkdir => true, :bits => nil do
  pkey = params[:name]
  bits = "-b #{params[:bits]}" if params[:bits]

  directory File.dirname(pkey) do
    mode 0700
    owner node.c2c.user
    group node.c2c.group
    only_if { params[:mkdir] }
  end

  execute "ssh-keygen -t #{params[:type]} -f #{pkey} #{bits} -N ''" do
    user node.c2c.user
    group node.c2c.group
    not_if { File.exists?(pkey) }
  end

  ruby_block "store ssh pubkey" do
    block do
      node.set[:c2c][:ssh_pubkey][pkey] = File.open("#{pkey}.pub") { |f| f.gets }
    end
  end
end
