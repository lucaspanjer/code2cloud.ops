#!/usr/bin/ruby

git_homes='/home/code2cloud/git-root'

Dir.glob("#{git_homes}/*") do |proj_git_home|
    print "Processing #{proj_git_home}\n"
    
    unless File.directory?("#{proj_git_home}/.ssh")
      Dir.mkdir("#{proj_git_home}/.ssh/")
    end
    filename = "#{proj_git_home}/.ssh/config"
    content = "Host *\n    StrictHostKeyChecking no\n"
    File.open(filename, 'w') {|f| f.write(content) }
    print `ssh-keygen -t rsa -f #{proj_git_home}/.ssh/id_rsa -N "" -C "Used by Code2Cloud to fetch external source repositories"`

end