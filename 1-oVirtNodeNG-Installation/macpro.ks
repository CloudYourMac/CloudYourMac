# Language and keyboard

lang en_GB.UTF-8
keyboard --vckeymap=gb --xlayouts=''

#timezone
timezone Europe/London --ntpservers=time.google.com

#Host config
%include /tmp/hostconfig.ks

#Root Password
rootpw --plaintext supersecure

#Bootloader
bootloader --location=none

# Disks
ignoredisk --only-use=disk/by-path/pci-0000:0e:00.0-ata-1

# Partitions
clearpart --all --initlabel --disklabel=gpt
bootloader --timeout=10

# System Partitions
reqpart --add-boot

# Physical Volume
part pv.01 --size=102400
part /gluster --label "Gluster" --size=1 --grow --fstype xfs

# Volume Group
volgroup onn pv.01

# Logical Volumes

# Thick Volumes
logvol swap --vgname=onn --fstype=swap --size=4096 --name=swap

# Thin Pool
logvol none  --size=1 --grow --thinpool --name=pool0 --vgname=onn

# Thin Volumes 
logvol / --vgname=onn  --thin --fsoptions="defaults,discard" --poolname=pool0 --fstype=xfs  --size=10240 --name=root
logvol /home --vgname=onn  --thin --fsoptions="defaults,discard" --poolname=pool0 --fstype=xfs  --size=10240 --name=home
logvol /tmp --vgname=onn  --thin --fsoptions="defaults,discard" --poolname=pool0 --fstype=xfs  --size=10240 --name=tmp
logvol /var --vgname=onn  --thin --fsoptions="defaults,discard" --poolname=pool0 --fstype=xfs  --size=20480 --name=var
logvol /var/log --vgname=onn  --thin --fsoptions="defaults,discard" --poolname=pool0 --fstype=xfs  --size=10240 --name=var_log
logvol /var/log/audit --vgname=onn  --fsoptions="defaults,discard" --thin --poolname=pool0 --fstype=xfs  --size=4096 --name=var_log_audit

# Install 
cmdline
liveimg --url="file:///run/install/repo/ovirt-node-ng-image.squashfs.img"

firstboot --reconfig
selinux --enforcing

reboot

%pre --erroronfail
exec < /dev/tty6 > /dev/tty6 2> /dev/tty6
chvt 6

 read -p "Enter MacPro Number  : " HOST_NUM

echo
sleep 1

IP=192.168.55.$((150 + $HOST_NUM))
GATEWAY=192.168.55.1
NETMASK=255.255.255.0
DNS=192.168.55.1
HOSTNAME=ovirt-macpro-$HOST_NUM.lab

echo "IP Address : $IP"
echo "Gateway    : $GATEWAY"
echo "Netmask    : $NETMASK"
echo "DNS        : $DNS"

echo "Hostname   : $HOSTNAME"

 read -p "Are details correct? Enter 'yes' to continue or anything else to exit :" CONFIRM

 if [ "$CONFIRM" != "yes"  ]; then

  echo "Details not confirmed, exiting"
  sleep 5

  chvt 1
  exec < /dev/tty1 > /dev/tty1 2> /dev/tty1  

  exit 1

 else

  #echo "network --device team0 --activate --bootproto static --ip=$IP --netmask=$NETMASK --gateway=$GATEWAY --nameserver=$DNS --teamslaves=\"enp11s0'{\\\"prio\\\": 100}',enp12s0'{\\\"prio\\\": 100}'\" --teamconfig=\"{\\\"runner\\\": {\\\"name\\\": \\\"activebackup\\\"}}\" --hostname=$HOSTNAME" > /tmp/hostconfig.ks

    echo "network  --activate --bootproto static --ip=$IP --netmask=$NETMASK --gateway=$GATEWAY --nameserver=$DNS --device=enp11s0 --ipv6=auto --activate --hostname=$HOSTNAME" > /tmp/hostconfig.ks

  chvt 1
  exec < /dev/tty1 > /dev/tty1 2> /dev/tty1

fi

%end

# Post Script
%post --erroronfail
set -x

# Create boot new boot entry
efibootmgr | grep "*" | cut -d '*' -f 1 | sed 's/Boot//g' | xargs -I %s efibootmgr -b %s -B
efibootmgr -c -l "\EFI\centos\grubx64.efi" -L "oVirt Node Next" -d /dev/disk/by-path/pci-0000:0e:00.0-ata-1 -p 1 

# Finalize Ovirt Installation
imgbase layout --init

# Don't mount gluster partition
mv /etc/fstab /etc/fstab.orig
cat /etc/fstab.orig | grep -v "gluster" > /etc/fstab

%end