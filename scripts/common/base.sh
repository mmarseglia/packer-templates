#!/bin/sh

# set the date
yum install -y ntpdate ntp
service ntpd stop
ntpdate -s time.nist.gov
service ntpd start

# update all packages
yum -y update
