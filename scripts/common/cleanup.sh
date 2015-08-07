#!/bin/sh

/bin/rm -rf *.iso

# clean up the temp directory
/bin/rm -rf /tmp/*

# remove the anaconda kickstart config file
/bin/rm -f /root/anaconda-ks.cfg

# this consolidates the disk
dd if=/dev/zero of=/EMPTY bs=1M
sync
/bin/rm -f /EMPTY
sync

# create this script and save on the template so it can be re-run if the
# template is updated.
cat > /root/template.sh <<TEMPLATE
#!/bin/bash
# Run this script if you need to update the template.

# clean up yum cached packages
yum -y clean all

# remove all interface configuration files
for scr in /etc/sysconfig/network-scripts/ifcfg-*; do
       [[ -f "$scr" ]] || continue
       [[ "$scr" == */ifcfg-lo ]] && continue
       /bin/rm -f "$scr"
       done
> /etc/sysconfig/network

# set interface eth0 to start on boot with DHCP
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=dhcp
EOF

# remove ssh host keys
/bin/rm -rf /etc/ssh/ssh_host_*

# find all the files in /var/log and delete them
find /var/log -type f -exec /bin/rm -f {} \;

# RHEL7 Options
# empty machine-id file. systemd will regenerate UUID on boot
[[ -f /etc/machine-id ]] && > /etc/machine-id

# default to traditional network interface naming
[[ -f /etc/udev/rules.d/80-net-name-slot.rules ]] && ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules
TEMPLATE

chmod 700 /root/template.sh

# run the template script
/root/template.sh

# remove root's history
/bin/rm -f /root/.bash_history
unset HISTFILE
