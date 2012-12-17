default[:c2c][:backup_mount] = "/home/backup"
default[:c2c][:backup_device] = nil
default[:c2c][:authorized_keys] = [{:name => "vcloud", :keys => []}]

default[:c2c][:admin_mail_sender][:host] = "smtp.gmail.com"
default[:c2c][:admin_mail_sender][:username] = "test@tasktop.com"
default[:c2c][:admin_mail_sender][:password] = "lessEqualsMore"
default[:c2c][:admin_email] = "clint.morgan@tasktop.com"

default[:c2c][:mail_sender][:host] = "smtp.gmail.com"
default[:c2c][:mail_sender][:port] = "587"
default[:c2c][:mail_sender][:username] = "c2c-sender@tasktop.com"
default[:c2c][:mail_sender][:password] = "c2c12345c2c"
default[:c2c][:mail_sender][:starttls] = "true"
default[:c2c][:mail_sender][:from] = "\"Code2Cloud Team\" <noreply@tasktop.com>"

default[:c2c][:proxy_environment][:http_proxy] = false
default[:c2c][:proxy_environment][:http_proxy_port] = 80
default[:c2c][:proxy_environment][:https_proxy] = false
default[:c2c][:proxy_environment][:https_proxy_port] = 80
default[:c2c][:proxy_environment][:no_proxy_prefix] = false