#!/bin/sh
# Red Hat 7 specific VMware installation tasks
#
# import VMware GPG keys
rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-DSA-KEY.pub
rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub

# Add VMware repository
cat > /etc/yum.repos.d/vmware-tools.repo <<-EOF
[vmware-tools]
name = VMware Tools
baseurl = http://packages.vmware.com/packages/rhel7/x86_64/
enabled = 1
gpgcheck = 1
EOF

# Install OpenVM Tools Deploy package. This is needed for VMs that will be
# templates. See https://partnerweb.vmware.com/GOSIG/RHEL_7.html
yum install -y open-vm-tools-deploypkg
