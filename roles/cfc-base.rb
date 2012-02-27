name "cfc-base"
run_list "role[cfc-env]", "emacs", "cfc_java", "cfc::authorized_keys", "sudo"

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
