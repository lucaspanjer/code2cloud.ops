define :cfc_backup do

  #:enable adds fstab entry
  mount node.cfc.backup_mount do
    device node.cfc.backup_device
    fstype "nfs"
    options "rw"
    action [:mount, :enable]
    only_if { node.cfc.backup_device }
  end
end
