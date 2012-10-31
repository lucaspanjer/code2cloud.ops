define :c2c_backup do

  #:enable adds fstab entry
  mount node.c2c.backup_mount do
    device node.c2c.backup_device
    fstype "nfs"
    options "rw"
    action [:mount, :enable]
    only_if { node.c2c.backup_device }
  end
end
