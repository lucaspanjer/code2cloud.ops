name "c2c-all"
run_list "role[c2c-base]", "role[c2c-task]", "role[c2c-db]", "role[c2c-dmz]", 
  "role[c2c-hmaster]", "role[c2c-hub]", "role[c2c-mta]", "role[c2c-nexus]", "role[c2c-scm]"



