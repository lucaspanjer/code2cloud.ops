version "0.1"
depends "cfc"
depends "tomcat"
depends "etchosts"
depends "ntp"
description "Shared base cookbook for cfc services"

recipe "cfc_server", "default install"
recipe "cfc_server::tc-instance", "create another tomcat instance"
