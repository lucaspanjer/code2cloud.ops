#!/bin/sh

knife ssh role:cfc-dmz -x vcloud 'sudo chef-client -E cfc-normal'
