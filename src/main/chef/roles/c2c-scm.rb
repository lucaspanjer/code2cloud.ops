name "c2c-scm"
run_list "role[c2c-base]", "c2c_scm"

# Doing the override here so that they will get merged together when multiple roles on the same node.
override_attributes(
:c2c => {
  :server => {
    :backup => {
      :directories => ["git-root", "maven-repo"]  
    }
  }
}
)


