name "c2c-env"

# ROLE for Code2Cloud Early access environment properties (https://r.tasktop.com/)

override_attributes \
:mysql => {
  :server_root_password => "REDACTED",
  :server_debian_password => "REDACTED",
  :server_repl_password => "REDACTED",
},
:c2c => {
  :server => {
    :deploy_type => "remote",
    :job => "Server",
    :build => false, #1861,
  },
  :hosts => {
     "hub"           => { :ipaddress => "192.168.0.154", :description => "Hub node" },
     "nexus"         => { :ipaddress => "192.168.0.154",  :description => "Nexus Repository" },
     "db"            => { :ipaddress => "192.168.0.154",  :description => "Database Server" },
     "dmz"           => { :ipaddress => "192.168.0.154",   :description => "DMZ node" },
     "hudson_master" => { :ipaddress => "192.168.0.154",  :description => "Hudson Master" },
     "hudson_slave"  => { :ipaddress => "192.168.0.155",  :description => "Hudson Slave" },
     "scm"           => { :ipaddress => "192.168.0.154",  :description => "SCM node" },
     "task"          => { :ipaddress => "192.168.0.154", :description => "Task node" },
     "profile"       => { :ipaddress => "r.tasktop.com", :description => "Public facing profile host" },
   },
  :mysql_pw => {
    "profile" => "REDACTED",
    "tasks" => "REDACTED",
    "wiki" => "REDACTED",
  },
  :artifacts => {
    :http_user => "testuser",
    :http_password => "REDACTED"
  },
  :github => {
    :consumer_key => "a30115eb45f34f83a4a5",
    :consumer_secret => "REDACTED"
  },
    #NOTE We don't provide the DMZ role. just manually write it. 
    # This is because we need it to act as a virtual host for multiple envs
  :dmz => {
    :servername => "r.tasktop.com",
    :go_daddy_bundle_crt => "REDACTED"
  },
  :hub => {
    :prefix_path => "",
    :invitation_only => true,
    :public_ssh_port => 22,
    :internal_ssh_port => 22
  },
  :nexus => {
    :port => "7070"
    },
  :tomcat => {
    :authbind => "yes"
  },
  :authorized_keys => [{
    :name => "vcloud",
      :keys => ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAz6V7/M+Ui5VSmwc/RdyucIYFgPwoILJCRdFs78RnCEWmYxle9oHKz5GhOgsSJBRvddiiy7kliwdmSguLe21OYSzvFnB/kVPNCMUrNEXCZGsQKqp+K9qbf6F+s5kAynWPKp/p/56lU3gJ9+Lc+tX3erAwNHJM3Y7WdHJBSKzUAGTYBtOf47XEJGXDn7ggVQzMO6OETxb6xAIeHbwGdPdFMMQE9iDGu5rfgIxdxYeVH9SXbzd4mXSQpk6Zyv8TcCWbCZxDILynkkBN0j8TOeSGt8tusRGinBdKB4drZajc35s329kFm5DNj/Vikmv2A8D8mb+qDRZdBtTueoZp/gO+IQ== cmorgan",
                 "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr17ygEXkXAqc5lwvQ5YvWXZLv2v6UtSVzzq4ELuntMc6opvbr8VW0VrBlemctYCL45XBzUyfIQWLryOAF6qoxuoniS+5BBGOSy5XiIq8ZnwtqQ2MCfO7+/Vp0lIzoK+74iIjrly7NjdMV3uluW6jpt/XLdN5ieayflHvIhFcIRjnCHCTZRLyilUuKg+wkld6tqEbG7EhBnhZvgBzk9d/oNj8a7XBYKC6fI4LnU4PdmRkLBtZ5JwjbSl5CQw6taRs5CJKBmhDZ893yI+djcEz7dJzL3BbOiZII2qQW3pIMAuqzqtl6ef1mTlWkju5GjJHvfwtYQ+Ff4aFRKM/HlXvLw== lucas"]
  }]
}