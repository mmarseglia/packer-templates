# ==RHEL 7 Kickstart Script
#
# This is a Kickstart Script to automate the installation of RedHat Enterprise
# Linux (RHEL) 7.  There have been changes between RHEL 6 and 7.  Please read
# the RHEL documentation for more information on those changes.
# https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/pdf/Migration_Planning_Guide/Red_Hat_Enterprise_Linux-7-Migration_Planning_Guide-en-US.pdf
#
# The Kickstart Configuration requires boot media that contains the installation
# packages.  A "boot only" cdrom/dvd image is not sufficient.  You must provide
# media to perform a full installation.
#
# This Kickstart Configuration is meant to create a virtual machine (VM) for use
# with Vagrant. Required packages for VM tools for the VirtualBox and VMware hypervisors are
# installed. Vagrant user name, group, and ssh keys are configured.
#
# After installation the operating system is updated.
#
# ===Authors
# mike@marseglia.org
#
install
cdrom
lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'
network --bootproto=dhcp --activate --ipv6=auto --device=link --hostname=rhel71
rootpw --plaintext vagrant
firewall --disable
authconfig --enableshadow --passalgo=sha512
selinux --permissive
timezone America/New_York --isUtc
bootloader --location=mbr --boot-drive=sda --append="net.ifnames=0 crashkernel=auto rhgb quiet" --timeout=0
unsupported_hardware

text
skipx
zerombr

clearpart --all
autopart --type=lvm --fstype=ext4

auth  --useshadow
firstboot --disabled
eula --agreed
reboot

%packages --ignoremissing --nobase --excludedocs
@core
@Development Tools
dkms
sudo
ntpdate
ntp
yum-utils
bzip2
kernel-devel
kernel-headers
-ipw2100-firmware
-ipw2200-firmware
-ivtv-firmware
%end

%post --log=/root/ks-post.log
#!/bin/sh

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin

# remove tty requirement for sudo
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# set the date when the VM image was created
date > /etc/vagrant_box_build_time

groupadd -g 501 vagrant
useradd vagrant -u 501 -g vagrant -G wheel
echo "vagrant"|passwd --stdin vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

mkdir -pm 700 /home/vagrant/.ssh
curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
%end
