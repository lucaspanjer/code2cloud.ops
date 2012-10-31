define :c2c_disk, :device => "/dev/sdb", :type => "ext3" do
  device = params[:device]
  partition = "#{device}1"

  directory params[:name] do
    recursive true
  end

  script "format #{device}" do
    interpreter "bash"
    code <<-EOH
      echo "#{['n', 'p', '1', '1', ' ', 'w'].join($/)}" | fdisk #{device}
      mkfs -t #{params[:type]} #{partition}
      tune2fs -m 1 #{partition}
    EOH

    only_if { ::File.blockdev?(device) }
    not_if { ::File.blockdev?(partition) }
  end

  mount params[:name] do
    device partition
    fstype params[:type]
    options "defaults"
    action [:mount, :enable]
    only_if { ::File.blockdev?(partition) }
  end
end
