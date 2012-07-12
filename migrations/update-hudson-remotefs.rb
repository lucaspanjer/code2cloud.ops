#!/usr/bin/ruby

hudson_homes='/home/code2cloud/hudson-homes'

Dir.glob("#{hudson_homes}/*") do |proj_h_home|
  
  for file in ["#{proj_h_home}/config.xml"] do
    print "Processing #{file}\n"
    if FileTest.exist?(file)
      content = File.read(file)
      unless content.match("<remoteFS>")
        content = content.gsub("</projectIdentifier>", "</projectIdentifier>\n      <remoteFS>/home/c2c/hudson</remoteFS>")
      end

      content = content.gsub("<remoteFS>/home//c2c</remoteFS>", "<remoteFS>/home/c2c/hudson</remoteFS>")
      
      #print content.match("<remoteFS>.*?\n")
      #print content
      File.open(file, 'w') {|f| f.write(content) }
    else 
      print "!!! #{file} does not exist\n"
    end
    print "\n"
  end

end
