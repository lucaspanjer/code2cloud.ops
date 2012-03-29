#!/bin/sh

#Script to update the existing hudson wars with the new template. Container should already be stopped

HUDSON_BASE_DIR=/home/code2cloud/hudson-homes/
HUDSON_TEMPLATE_WAR=/opt/code2cloud/configuration/template/hudson-war/hudson.war
HUDSON_WEBAPPS_DIR=/opt/code2cloud/webapps

EXISTING_WEBAPPS=`ls $HUDSON_WEBAPPS_DIR/*hudson.war`

echo 'removing users plugin data'
rm -rf $HUDSON_BASE_DIR/*/plugins/*

echo 'removing existing webapps'
rm -rf $HUDSON_WEBAPPS_DIR/*hudson

for WEBAPP in $EXISTING_WEBAPPS
do
    APPID=${WEBAPP#$HUDSON_WEBAPPS_DIR/alm#s#}
    APPID=${APPID%#hudson.war}

    echo Updating webapp $WEBAPP for app $APPID

    TEMP_WAR_LOCATION=/tmp/hudson-$APPID
    mkdir $TEMP_WAR_LOCATION
    cp $HUDSON_TEMPLATE_WAR $TEMP_WAR_LOCATION
    cd $TEMP_WAR_LOCATION
    jar -xf hudson.war WEB-INF/web.xml
    
    # Place the hudson home for this app in the web.xml
    sed "s_<env-entry-value>_<env-entry-value>$HUDSON_BASE_DIR$APPID _" WEB-INF/web.xml > WEB-INF/web.xml.mod
    mv  WEB-INF/web.xml.mod  WEB-INF/web.xml

    jar -uf hudson.war WEB-INF/web.xml
    mv hudson.war $WEBAPP
    chown  tomcat6:tomcat6 $WEBAPP 
    rm -rf $TEMP_WAR_LOCATION
done


