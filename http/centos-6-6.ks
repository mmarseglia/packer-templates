install
text
skipx
lang en_US.UTF-8
keyboard us
network --onboot yes --device eth0 --bootproto dhcp --noipv6
rootpw --plaintext vagrant
firewall --enabled --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone America/NewYork
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"

zerombr

clearpart --all --initlabel
autopart

auth  --useshadow  --enablemd5
firstboot --disabled
reboot

%packages --ignoremissing
@core
@Development Tools
sudo
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
