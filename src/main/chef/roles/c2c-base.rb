name "c2c-base"
run_list "role[c2c-env]", "c2c_java", "c2c::authorized_keys", "c2c::proxy_environment" 

override_attributes \
:java => {
  :install_flavor => "sun"
},
:authorization => {
  :sudo => {
    :users => ["vcloud"],
    :groups => ["admin"],
    :passwordless => true
  }
}
