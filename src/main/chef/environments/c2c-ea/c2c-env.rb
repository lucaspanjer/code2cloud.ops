name "c2c-env"

# ROLE for Code2Cloud Early access environment properties (https://r.tasktop.com/)

override_attributes \
:java => {
  :java_home => "/usr/lib/jvm/java-6-sun/jre"
},
:tomcat => {
  :second_service => true
},
:c2c => {
  :server => {
      :tomcat => {
        :authbind => "yes"
      },
      :s3 => {
        :access_key_id => "AKIAI6FIC7DBENCWERKA"
      },
  },
  :hosts => {
     "hub"           => { :ipaddress => "192.168.51.29", :description => "Hub node" },
     "nexus"         => { :ipaddress => "192.168.51.29",  :description => "Nexus Repository" },
     "db"            => { :ipaddress => "192.168.51.29",  :description => "Database Server" },
     "dmz"           => { :ipaddress => "192.168.51.29",   :description => "DMZ node" },
     "hudson_master" => { :ipaddress => "192.168.51.29",  :description => "Hudson Master" },
     "hudson_slave"  => { :ipaddress => "192.168.51.30",  :description => "Hudson Slave" },
     "scm"           => { :ipaddress => "192.168.51.29",  :description => "SCM node" },
     "task"          => { :ipaddress => "192.168.51.29", :description => "Task node" },
     "profile"       => { :ipaddress => "r.tasktop.com", :description => "Public facing profile host" },
   },
  :github => {
    :consumer_key => "a30115eb45f34f83a4a5"
  },
 :hub => {
    :prefix_path => "",
    :invitation_only => true,
    :public_ssh_port => 22,
    :internal_ssh_port => 22,
    :remember_me_key => "p928375614k6j/14m43iotgha''423j56;11",
    :has_internal_services => true,

  },
  :nexus => {
    :port => "7070"
    },
  :authorized_keys => [{
    :name => "vcloud",
      :keys => ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAz6V7/M+Ui5VSmwc/RdyucIYFgPwoILJCRdFs78RnCEWmYxle9oHKz5GhOgsSJBRvddiiy7kliwdmSguLe21OYSzvFnB/kVPNCMUrNEXCZGsQKqp+K9qbf6F+s5kAynWPKp/p/56lU3gJ9+Lc+tX3erAwNHJM3Y7WdHJBSKzUAGTYBtOf47XEJGXDn7ggVQzMO6OETxb6xAIeHbwGdPdFMMQE9iDGu5rfgIxdxYeVH9SXbzd4mXSQpk6Zyv8TcCWbCZxDILynkkBN0j8TOeSGt8tusRGinBdKB4drZajc35s329kFm5DNj/Vikmv2A8D8mb+qDRZdBtTueoZp/gO+IQ== cmorgan",
                 "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr17ygEXkXAqc5lwvQ5YvWXZLv2v6UtSVzzq4ELuntMc6opvbr8VW0VrBlemctYCL45XBzUyfIQWLryOAF6qoxuoniS+5BBGOSy5XiIq8ZnwtqQ2MCfO7+/Vp0lIzoK+74iIjrly7NjdMV3uluW6jpt/XLdN5ieayflHvIhFcIRjnCHCTZRLyilUuKg+wkld6tqEbG7EhBnhZvgBzk9d/oNj8a7XBYKC6fI4LnU4PdmRkLBtZ5JwjbSl5CQw6taRs5CJKBmhDZ893yI+djcEz7dJzL3BbOiZII2qQW3pIMAuqzqtl6ef1mTlWkju5GjJHvfwtYQ+Ff4aFRKM/HlXvLw== lucas"]
  }]
}
