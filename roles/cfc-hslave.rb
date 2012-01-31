name "cfc-hslave"
run_list "role[cfc-base]", "jce_policy", "cfc_hslave", "grails"

override_attributes \
:cfc => { :authorized_keys_dir => "/etc/ssh" },
:grails => { :user => "builder" }
