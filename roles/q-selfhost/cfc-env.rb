name "cfc-env"

# ROLE for Code2Cloud Dev environment properties (https://q.tasktop.com/alm)x

override_attributes \
:mysql => {
  :server_root_password => "REDACTED",
  :server_debian_password => "REDACTED",
  :server_repl_password => "REDACTED",
},
:cfc => {
  :server => {
    :deploy_type => "local",
    :job => "Server",
    :build => 1832,
  },
  :hosts => {
     "hub"           => { :ipaddress => "192.168.0.151", :description => "Hub node" },
     "nexus"         => { :ipaddress => "192.168.0.151",  :description => "Nexus Repository" },
     "db"            => { :ipaddress => "192.168.0.151",  :description => "Database Server" },
     "dmz"           => { :ipaddress => "192.168.0.151",   :description => "DMZ node" },
     "hudson_master" => { :ipaddress => "192.168.0.151",  :description => "Hudson Master" },
     "hudson_slave"  => { :ipaddress => "192.168.0.152",  :description => "Hudson Slave" },
     "scm"           => { :ipaddress => "192.168.0.151",  :description => "SCM node" },
     "task"          => { :ipaddress => "192.168.0.151", :description => "Task node" },
     "profile"       => { :ipaddress => "q.tasktop.com", :description => "Public facing profile host" },
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
  :dmz => {
    :servername => "q.tasktop.com",
    :go_daddy_bundle_crt => "REDACTED"
  },
  :hub => {
    :prefix_path => "alm",
    :invitation_only => true
  },
  :nexus => {
    :port => "7070"
    }
}
