name "c2c-env"

# ROLE for Code2Cloud Dev environment properties (https://q.tasktop.com/alm)

override_attributes \
:java => {
  :java_home => "/usr/lib/jvm/java-7-oracle/jre"
},
:tomcat => {
  :second_service => true
},
:c2c => {
  :server => {
      :s3 => {
        :access_key_id => "AKIAI6FIC7DBENCWERKA"
      },
  },
  :hosts => {
     "hub"           => { :ipaddress => "192.168.51.20", :description => "Hub node" },
     "nexus"         => { :ipaddress => "192.168.51.20",  :description => "Nexus Repository" },
     "db"            => { :ipaddress => "192.168.51.20",  :description => "Database Server" },
     "dmz"           => { :ipaddress => "192.168.51.20",   :description => "DMZ node" },
     "hudson_master" => { :ipaddress => "192.168.51.20",  :description => "Hudson Master" },
     "hudson_slave"  => { :ipaddress => "192.168.51.21",  :description => "Hudson Slave" },
     "scm"           => { :ipaddress => "192.168.51.20",  :description => "SCM node" },
     "task"          => { :ipaddress => "192.168.51.20", :description => "Task node" },
     "profile"       => { :ipaddress => "q.tasktop.com", :description => "Public facing profile host" },
   },
  :service_hosts => [
         { :service_types => ["BUILD", "TASKS", "WIKI", "SCM", "MAVEN", "TRUSTED_PROXY"], :ip_addresses => ["192.168.51.20"] },
         { :service_types => ["BUILD_SLAVE"], :ip_addresses => ["192.168.51.21", "192.168.51.22"] }
    ], 
  :github => {
    :consumer_key => "a30115eb45f34f83a4a5"
  },
  :hub => {
    :prefix_path => "/alm",
    :invitation_only => true,
    :remember_me_key => "p928375614k6j/14m43iotgha''423j56;11",
    :has_internal_services => true,
    :additional_properties => [
      "alm.hudsonSlave.build.directoriesToClean=/tmp,/home/c2c/hudson",
      "alm.databaseBacked.maxTenantsPerNode=200",
      "alm.diskBacked.maxTenantsPerNode=200",
      "alm.hudsonMaster.maxTenantsPerNode=200"
    ]
  },
  :hudson => {
    :update_plugins => false # We have custom gerrit plugin enabled for c2c project
  },
  :nexus => {
    :port => "7070"
    },
  :authorized_keys => [{
    :name => "vcloud",
      :keys => ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAz6V7/M+Ui5VSmwc/RdyucIYFgPwoILJCRdFs78RnCEWmYxle9oHKz5GhOgsSJBRvddiiy7kliwdmSguLe21OYSzvFnB/kVPNCMUrNEXCZGsQKqp+K9qbf6F+s5kAynWPKp/p/56lU3gJ9+Lc+tX3erAwNHJM3Y7WdHJBSKzUAGTYBtOf47XEJGXDn7ggVQzMO6OETxb6xAIeHbwGdPdFMMQE9iDGu5rfgIxdxYeVH9SXbzd4mXSQpk6Zyv8TcCWbCZxDILynkkBN0j8TOeSGt8tusRGinBdKB4drZajc35s329kFm5DNj/Vikmv2A8D8mb+qDRZdBtTueoZp/gO+IQ== cmorgan",
                "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr17ygEXkXAqc5lwvQ5YvWXZLv2v6UtSVzzq4ELuntMc6opvbr8VW0VrBlemctYCL45XBzUyfIQWLryOAF6qoxuoniS+5BBGOSy5XiIq8ZnwtqQ2MCfO7+/Vp0lIzoK+74iIjrly7NjdMV3uluW6jpt/XLdN5ieayflHvIhFcIRjnCHCTZRLyilUuKg+wkld6tqEbG7EhBnhZvgBzk9d/oNj8a7XBYKC6fI4LnU4PdmRkLBtZ5JwjbSl5CQw6taRs5CJKBmhDZ893yI+djcEz7dJzL3BbOiZII2qQW3pIMAuqzqtl6ef1mTlWkju5GjJHvfwtYQ+Ff4aFRKM/HlXvLw== lucas",
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8QBC2/XMcr+JSmiUER4OmP6n9ZgsoKSnhB4v0ab3Q+nIeU2kp4JWspueBicjvQ93ExsnHtzOIcXPXVvxYVH2PVNEFqpPzr8P18dkuOxImbrf1CzpQNePLHUF3xWpUh7qtGRh0TjqNQH/ifY1yWSuTgu9MjyEcpfIHLg9PtOYEbi4Fcg2SdBZPqbLleZZS2WmRXdWEM/eXBoFI48u1vGxGkWdWBMqPkScXHpYHycLVM51uJtcZCZrxyoXtjr+vMW3w9LwkiLTtfX/M1VxsOiTq39L8Mjrm94083hPdTC4zcRj1sCYBIsI4CMUTByVZJRu5aSQ88ESK28PS3cqsyCtF57FskcxyFsdWYSaM440+IkjLyeaV+N0yISmOvnyNSpIfXrSjIaMTukcbqTdHikFnqRyKSHIX/v2Pu3N6HUoO1zr4V9ZsZOTjZAxeOhHj20w2XdP2z+K/9tIjOJ0geHCFOGDo+CP2h3PEskCMlzK4KYZHg6Jst20k79JW+70LFrgsaYjJpBWkbjV1v8POvWCgzeh0zUR4jrxTKh1M4uFBeUWs1rXIy61gZvgzJgvMEo3Dh2GskWG77orKNXhljA+4QoPmaqtkOLLRuPuGrlDEfPZ9RIJTXVsEB+Nre4OGTtBCxDiuuGNI/GfRfqejIMd/FKWav6ZDpHgeyvQTm2Wu8w== michaelnelson@localadmins-MacBook-Pro.local"
               ]
    },{
    :name => "builder",
      :keys => ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWAmnaOvLEoKYjlE94lUEmJWaNB8NsSaHTRY8SUbGQeBernIdhlGku49OWYapzPYdyd2Zlp/PaPq9A5I64fuom9DLik71Av7pzYtxMGx1I95NITJhnw/Eik8gk10ib9CDj3R/q4hIGrUvFBfsH26rQ9YslLZmMxTelGojje30sbOMcySVfIsLrB2jXoNGzTtVFJr2p17k4X4uFDrp8gohk+3KjYdWNN9ZMsikVnDKpD3nYAJztoZhbfq3Tq6Hs6Ul4U0dOSMvXzH4h2XH8ZWvdHRAynJQNrCNl5HXZ/5Ik9T+bKaG2EDwrbrlktwZfCHNIiXcjYHr+FfmhIUhVrkCt vcloud@dev-q058.van.tasktop.com"
               ]
    }
  ]
}
