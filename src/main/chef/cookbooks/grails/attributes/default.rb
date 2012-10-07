default[:grails][:root_dir] = "/usr/share/grails"
default[:grails][:mirror] = "http://dist.springframework.org.s3.amazonaws.com/release/GRAILS"
default[:grails][:version] = "2.0.1"
default[:grails][:subdir] = "grails-#{node[:grails][:version]}"
default[:grails][:path] = "#{node[:grails][:root_dir]}/#{node[:grails][:subdir]}"
default[:grails][:bin] = "#{node[:grails][:path]}/bin"
default[:grails][:package] = "#{node[:grails][:subdir]}.zip"
default[:grails][:url] = "#{node[:grails][:mirror]}/#{node[:grails][:package]}"
default[:grails][:user] = "vcloud" #XXX >> role