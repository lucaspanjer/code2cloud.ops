#!/usr/bin/ruby

hudson_homes='/home/code2cloud/hudson-homes'

Dir.glob("#{hudson_homes}/*") do |proj_h_home|
  
  for file in ["#{proj_h_home}/config.xml", "#{proj_h_home}/hudson.plugin.buildlistener.xml"] do
    print "Processing #{file}\n"
    content = File.read(file)
    migrated_content = content.gsub("com.tasktop.code", "com.tasktop.c2c")
    #print migrated_content
    File.open(file, 'w') {|f| f.write(migrated_content) }
  end

end