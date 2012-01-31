name "cfc-env"

# ROLE for Code2Cloud Early access environment properties (https://r.tasktop.com/)

override_attributes \
:mysql => {
  :server_root_password => "REDACTED",
  :server_debian_password => "REDACTED",
  :server_repl_password => "REDACTED",
},
:cfc => {
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
  }
}
