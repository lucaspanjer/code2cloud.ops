name "cfc-base"
run_list "role[cfc-env]", "cfc_java", "cfc::authorized_keys", "cfc::proxy_environment" 

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
