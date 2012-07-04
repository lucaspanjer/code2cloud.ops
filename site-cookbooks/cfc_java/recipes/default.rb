if platform?("redhat", "oracleserver", "oracle")
  # FIXME this will not work anymore, need to agree to license agreement
  unless File.exists?("/usr/bin/java")
    raise "Must manually install from: http://www.oracle.com/technetwork/java/javase/downloads/jdk-6u31-download-1501634.html"
  end
else
  include_recipe "java"
end
