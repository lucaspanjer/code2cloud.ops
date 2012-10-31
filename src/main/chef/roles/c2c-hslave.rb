name "c2c-hslave"
run_list "role[c2c-base]", "jce_policy", "c2c_hslave"#, "grails"

override_attributes \
:c2c => { :authorized_keys_dir => "/etc/ssh" },
:grails => { :user => "builder" }
