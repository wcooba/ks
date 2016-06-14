#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use network installation
url --url="http://10.0.0.20/repo/centos/7/"
# Use text mode install
text
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=vda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_GB.UTF-8

# Network information
network  --bootproto=static --device=eth0 --gateway=10.0.0.1 --ip=10.0.0.34 --nameserver=10.0.0.6,10.0.0.1 --netmask=255.255.255.0 --noipv6 --activate
network  --hostname=gigatron-web01

# Root password
rootpw --iscrypted $6$zwmjMH0.QEIoMVXP$tAkt4zvZuehq8UXL0yeLvgiude9OHI.qzc29t24du.O.rhWBhUGGGQXvsO3C0iJ4CRdGXKQj.uHxXYyJmNSvl1
# Do not configure the X Window System
skipx
# System timezone
timezone Europe/Dublin --isUtc
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=vda
autopart --type=plain
# Partition clearing information
clearpart --all --initlabel --drives=vda

%packages
@core
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end
%post

#---- Install SSH key ----
mkdir -m0700 /root/.ssh/

cat <<EOF >/root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDk3ifnN3x/ekf0PMKkGctTzO9VlMKB47oXOZihKv2O9+yz0BG5lnph7hrV+nQ+jIQU5RiV6Y62buFBd/Zn/9+XQIDMurNrIecJ6qlpCkVCtGPGObe4Fzz9+zwidX6231RWhNipy2NaINaT63JZGD7T9Gw6k7/h9jsUppZcJKD5R3Z7JLe0HA/FW9k64kwjPEI3t/lA52fjhSBBo4Jn/H1v1ImedUpOW/G04Gu/rWs47EE+vEnk8VeooMdz6oyNr8kuGZ8V6l8r4EIr56T9H7Ds6w2CuPojDruf/0OJBubztWeSnOvYg5BrBa12rY6C3JKTLVdMpWt/pScGp/4nD6eb root@provisioning-srv
EOF

chmod 0600 /root/.ssh/authorized_keys
restorecon -R /root/.ssh/

#---- Remove repos ----
rm -rf /etc/yum.repos.d/*.repo
%end

