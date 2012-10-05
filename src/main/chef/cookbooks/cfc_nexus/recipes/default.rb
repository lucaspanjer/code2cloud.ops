cfc_user node.nexus.user

remote_directory node.nexus.work do
  source "m2-repo"
  files_owner node.nexus.user
  files_group node.nexus.user
  files_mode  0644
  owner node.nexus.user
  group node.nexus.user
  mode 0755
  not_if {File.exists?(node.nexus.work)}
end

include_recipe "nexus"
