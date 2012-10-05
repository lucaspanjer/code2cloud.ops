name "cfc-all"
run_list "role[cfc-base]", "role[cfc-task]", "role[cfc-db]", "role[cfc-dmz]", 
  "role[cfc-hmaster]", "role[cfc-hub]", "role[cfc-mta]", "role[cfc-nexus]", "role[cfc-scm]"



