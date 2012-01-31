name "cfc-hmaster"
run_list "role[cfc-base]", "cfc_hmaster"

# Doing the override here so that they will get merged together when multiple roles on the same node.
override_attributes(
:cfc => {
  :server => {
    :backup => {
      :directories => ["hudson-homes"]
    }
  }
}
)