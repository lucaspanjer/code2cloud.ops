version "0.1"
depends "c2c"
depends "tomcat"
depends "etchosts"
depends "ntp"
description "Shared base cookbook for c2c services"

recipe "c2c_server", "default install"
recipe "c2c_server::tc-instance", "create another tomcat instance"
