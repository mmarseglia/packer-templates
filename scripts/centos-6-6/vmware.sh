#!/bin/sh
# Install VMware Tools Operating Specific Packages (OSP)
# Using this method so that vmware tools are always available no matter how we
# build the image.
# https://packages.vmware.com/tools/docs/manuals/osp-esxi-51-install-guide.pdf

yum install -y perl fuse-libs

# make and enter temp directory
mkdir -p /tmp/vmware/iso

curl -O http://your.host.here/vmware/linux.iso
mount -oloop linux.iso /tmp/vmware/iso

# unpack vmware tools installer to temp directory
tar zxvf /tmp/vmware/iso/*.tar.gz -C /tmp/vmware

# Create silent answer file for VMware Tools Installer

# If you wish to change which Kernel modules get installed
# The last four entries (no,no,yes,no) map to the following:
#   VMware Host-Guest Filesystem
#   vmblock enables dragging or copying files
#   VMware automatic kernel modules
#   Guest Authentication
# and you can also change the other params as well
cat > /tmp/answer << __ANSWER__
/usr/bin
/etc/rc.d
/etc/init.d
/usr/sbin
/usr/lib/vmware-tools
yes
/usr/share/doc/vmware-tools
yes
yes
yes
yes
yes
yes

__ANSWER__

# run the vmware tools installer with the default options
/tmp/vmware/vmware-tools-distrib/vmware-install.pl < /tmp/answer

# clean up
umount /tmp/vmware/iso
/bin/rm -rf /tmp/vmware

# Remove udev rules for network devices
# this will re-populate on next reboot
/bin/rm -f /etc/udev/rules.d/70-persistent-net.rules

sed -i "s/HWADDR=.*//" /etc/sysconfig/network-scripts/ifcfg-eth0

sed -i "s/^start.*/start on stopped rc RUNLEVEL=[345] or starting gdm or starting kdm or starting prefdm/" /etc/init/vmware-tools.conf
