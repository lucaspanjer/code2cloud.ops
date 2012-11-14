name "c2c-env"

override_attributes \
:java => {
  :java_home => "/usr/lib/jvm/jdk1.6.0_37"
},
:mysql => {
  :bind_address => "127.0.0.1",
  :server_root_password => "welcome1",
  :server_debian_password => "welcome1",
  :server_repl_password => "welcome1",
},
:c2c => {
  :hosts => {
      "hub"           => { :ipaddress => "127.0.0.1", :description => "Hub node" },
      "db"            => { :ipaddress => "127.0.0.1",  :description => "Database Server" },
      "profile"       => { :ipaddress => "c2c.local", :description => "Public facing profile host" },
    },
   :server => {
      :backup => { :enabled => false},
      :email_log_errors_to_admin => false, 
    },
  :mysql_pw => {
    "profile" => "welcome1",
    "tasks" => "welcome1",
    "wiki" => "welcome1",
   },
  :hub => {
      :prefix_path => "",
      :invitation_only => false,
      :remember_me_key => "p923875614k6j/14m43iotgha''423j56;11",
      :has_internal_services => true,
      :protocol => "http",
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
        :keys => ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1DJmrzQpqCxvGk7G4dGLsXXvOEiA9pNTJTa5Jn+hnUrSP7A1ztJ7Z67FbGetZOUoGfafzpS2K4TbIqN+BQJlx/9mLBVnaAVZiPNPuvRi+0RDswy7caShi0mVfeGkW7MZZARrVAxGRm5NQsRgN9MrMeu1WL774VmeuoA8z3pUfL9tpb4x/TBmOmM3wSND5Vur8djaHTNha1QG51jV0c1O9dPrxoIHRa6IEVRR9++th5gRIN+4h2a9y7MagW1fsgtLH1lZUHF9TztUo7rHL4/jNfa+lkLc51VeK359C3Lln+mvSBEVljqIAWwa9L1NJnWH7uQF39b2XYQVI/Z1QWnRSQ== vcloud@dev-vm"]
    }]
}
