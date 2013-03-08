name "c2c-env"

override_attributes \
:java => {
  :java_home => "/usr/lib/jvm/jdk1.6.0_37"
},
:mysql => {
  :bind_address => "0.0.0.0"
},
:tomcat => {
  :second_service => true,
  :catalina_options => "-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"

},
:c2c => {
  :hosts => {
      "hub"           => { :ipaddress => "127.0.0.1", :description => "Hub node" },
      "db"            => { :ipaddress => "127.0.0.1",  :description => "Database Server" },
      "profile"       => { :ipaddress => "c2c.dev", :description => "Public facing profile host" },
    },
  :service_hosts => [
      { :service_types => ["BUILD", "TASKS", "WIKI", "SCM", "MAVEN", "TRUSTED_PROXY"], :ip_addresses => ["127.0.0.1"] },
      { :service_types => ["BUILD_SLAVE"], :ip_addresses => ["127.0.0.1"] }
    ], 
   :server => {
      :backup => { :enabled => false},
      :email_log_errors_to_admin => false, 
    },
  :hub => {
      :prefix_path => "",
      :invitation_only => false,
      :remember_me_key => "p923875614k6j/14m43iotgha''423j56;11",
      :has_internal_services => true,
      :protocol => "http",
      :additional_properties => [
      "alm.hudsonSlave.build.directoriesToClean=/tmp"
    ]

    },
  :github => {
    :consumer_key => "LOCAL",
    :consumer_secret => "LOCAL"
  },
  :authorized_keys => [{
      :name => "vcloud",
        :keys => ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAz6V7/M+Ui5VSmwc/RdyucIYFgPwoILJCRdFs78RnCEWmYxle9oHKz5GhOgsSJBRvddiiy7kliwdmSguLe21OYSzvFnB/kVPNCMUrNEXCZGsQKqp+K9qbf6F+s5kAynWPKp/p/56lU3gJ9+Lc+tX3erAwNHJM3Y7WdHJBSKzUAGTYBtOf47XEJGXDn7ggVQzMO6OETxb6xAIeHbwGdPdFMMQE9iDGu5rfgIxdxYeVH9SXbzd4mXSQpk6Zyv8TcCWbCZxDILynkkBN0j8TOeSGt8tusRGinBdKB4drZajc35s329kFm5DNj/Vikmv2A8D8mb+qDRZdBtTueoZp/gO+IQ== cmorgan",
                   "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr17ygEXkXAqc5lwvQ5YvWXZLv2v6UtSVzzq4ELuntMc6opvbr8VW0VrBlemctYCL45XBzUyfIQWLryOAF6qoxuoniS+5BBGOSy5XiIq8ZnwtqQ2MCfO7+/Vp0lIzoK+74iIjrly7NjdMV3uluW6jpt/XLdN5ieayflHvIhFcIRjnCHCTZRLyilUuKg+wkld6tqEbG7EhBnhZvgBzk9d/oNj8a7XBYKC6fI4LnU4PdmRkLBtZ5JwjbSl5CQw6taRs5CJKBmhDZ893yI+djcEz7dJzL3BbOiZII2qQW3pIMAuqzqtl6ef1mTlWkju5GjJHvfwtYQ+Ff4aFRKM/HlXvLw== lucas"]
                   },{
      :name => "builder",
      # NOTE this is the autgenerated key, will change with each build.
        :keys => ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSBy7TLkjBYVt0CKvuUOdn1jNpq4ZQigBq8JVtfFVYL/D3pc+zpNCdI9oBT46wwanHLDDbLb0z+doxY3iaIHCUYvlxdmjNT18VGcustwyku1ojlaVAORNkQief//fLrVj081eUcXiPZFxj89A6rPyyAE7F0SSBtq+JL8WNq9iIrvCFysrkB20XImcwk61AQAFAV9XXckMYS2PbEXN0Wf6mmmW2g7G1vVgcxxP5uQW8feTOi5g8nt1lnYbj88xhnScmU6Q82Q4LOf69Md3oXEDVvbQmsjC6oN8/3aWNac4R0R2/pAeSG03pQT2X/mN1DFscY2iYxpuKq9/7Fpmd6n1z vcloud@dev"]
    }]
}
