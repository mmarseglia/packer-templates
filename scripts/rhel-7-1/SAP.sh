#!/bin/sh
#
# install extra packages
yum -y groupinstall large-systems network-file-system-client performance compat-libraries
yum -y install uuidd compat-libstdc++-33 libstdc++.so.5 nfs-utils rpc-bind "kernel-devel-$(uname -r)" perl

# X Windows per john Bennett
yum -y install xclock xauth libXext libXp libXtst

# 7/13/2015 Install C Shell per John Bennett
yum -y install csh

# SAP settings
cat >  /etc/sysctl.d/sap.conf <<EOF
# SAP settings
kernel.sem=1250 256000 100 1024
vm.max_map_count=2000000
kernel.shmmax = 33136829430
kernel.msgmni = 1024"
EOF

cat > /etc/security/limits.d/99-sap.conf <<EOF
@sapsys hard nofile 32800
@sapsys soft nofile 32800
@sapsys soft nproc unlimited
EOF

# enable NFS client
systemctl enable rpcbind

# allow kmstuned to use NFS
setsebool -P ksmtuned_use_nfs 1
