if platform?(%w{redhat})
  unless File.exists?("/usr/bin/java")
    remote_file "/tmp/install-java.bin" do
      source "http://download.oracle.com/otn-pub/java/jdk/6u31-b04/jdk-6u31-linux-x64-rpm.bin"
      mode "0777"
    end
    execute "/tmp/install-java.bin" do
    end
  end
else
  include_recipe "java"
end
