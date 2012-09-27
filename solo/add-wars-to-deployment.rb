#!/usr/bin/ruby

require 'rubygems'

usage ="add-wars-to-deployment <deployment-dir> <wars-dir> \n"

if ARGV.length != 2
  print usage;
  exit(1)
end

deployment_dir=ARGV[0]
war_dir=ARGV[1]

if !File.exists?(deployment_dir)
  print "#{deployment_dir} deployment dir does not exist"
  exit (1)
end

if !File.exists?(war_dir)
  print "#{war_dir} war dir does not exist"
  exit (1)
end

FileUtils.cp(Dir.glob("#{war_dir}/**/profile.web*.war"), "#{deployment_dir}/cookbooks/cfc_hub/files/default/")
FileUtils.cp(Dir.glob("#{war_dir}/**/tasks.web*.war"), "#{deployment_dir}/cookbooks/cfc_task/files/default/")
FileUtils.cp(Dir.glob("#{war_dir}/**/wiki.web*.war"), "#{deployment_dir}/cookbooks/cfc_task/files/default/")
FileUtils.cp(Dir.glob("#{war_dir}/**/services.web*.war"), "#{deployment_dir}/cookbooks/cfc_scm/files/default/")
FileUtils.cp(Dir.glob("#{war_dir}/**/services.web*.war"), "#{deployment_dir}/cookbooks/cfc_scm/files/default/")



