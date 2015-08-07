#!/bin/sh
#

# register this system with RHEL subscription manager, auto attach to available
# subscriptions so we can get updates
subscription-manager register --username your@email.address --password password --auto-attach
subscription-manager refresh

# enable extra RHEL repositories
yum-config-manager --enable rhel-7-server-optional-rpms

# delta rpm allows installation of incremental update packages, minimizing
# time needed to download updates.
yum -y install deltarpm
