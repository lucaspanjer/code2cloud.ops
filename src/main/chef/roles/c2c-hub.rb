name "c2c-hub"
run_list "role[c2c-base]", "jce_policy", "c2c_hub"
