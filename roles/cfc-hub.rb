name "cfc-hub"
run_list "role[cfc-base]", "jce_policy", "cfc_hub"
