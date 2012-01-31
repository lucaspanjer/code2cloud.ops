remote_directory "#{node.java.java_home}/jre/lib/security" do
  files_owner "root"
  files_group "root"
  files_mode  0644
end
