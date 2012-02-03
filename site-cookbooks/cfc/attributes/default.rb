default[:cfc][:backup_mount] = "/home/backup"
default[:cfc][:backup_device] = nil
default[:cfc][:authorized_keys] = ["vcloud"]

default[:cfc][:admin_mail_sender][:host] = "smtp.gmail.com"
default[:cfc][:admin_mail_sender][:username] = "test@tasktop.com"
default[:cfc][:admin_mail_sender][:password] = "lessEqualsMore"
default[:cfc][:admin_email] = "clint.morgan@tasktop.com"

default[:cfc][:mail_sender][:host] = "smtp.gmail.com"
default[:cfc][:mail_sender][:username] = "c2c-sender@tasktop.com"
default[:cfc][:mail_sender][:password] = "c2c12345c2c"

default[:cfc][:artifacts][:base_url] = "https://q.tasktop.com/alm/s/c2c"
default[:cfc][:hudson_url] = "#{node.cfc.artifacts.base_url}/hudson"
