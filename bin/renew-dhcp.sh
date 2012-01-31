#!/bin/sh

#if the VM was pxe booted; this could be automated in preseed.cfg
rm /etc/udev/rules.d/70-persistent-net.rules
rm /var/lib/dhcp3/dhclient.eth0.leases
