#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use CDROM installation media
cdrom
# Use graphical install
text
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=gb --xlayouts='gb'
# System language
lang en_GB.UTF-8

# Network information
network  --bootproto=static --device=enp0s3 --gateway=10.0.0.1 --ip=10.0.0.29 --nameserver=10.0.0.1,10.0.0.6 --netmask=255.255.255.0 --onboot=yes --noipv6
#network  --bootproto=dhcp --device=em2 --onboot=off --ipv6=auto
#network  --bootproto=dhcp --device=em3 --onboot=off --ipv6=auto
#network  --bootproto=dhcp --device=em4 --onboot=off --ipv6=auto
network  --hostname=gigatron-hv-test.automaticamusments.local

# Root password
rootpw --iscrypted $6$Dc/ze4L2JYwiW9Xl$JUzLGLUir6ciVmuUwHHMr9NqldC8eYL8kRfHNJY//5u9ECJ3tK/wYgM4C7WU9cA8HBKbL0ulV6l6ypDitsJ600
# System services
services --disabled="chronyd"
# System timezone
timezone Europe/Dublin --isUtc --nontp
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
# Partition clearing information
clearpart --drives=sda --all
# Disk partitioning information
part / --fstype="ext4" --ondisk=sda --size=15356 --label=root
part /boot/efi --fstype="efi" --ondisk=sda --size=500 --fsoptions="umask=0077,shortname=winnt" --label=boot
part swap --fstype="swap" --ondisk=sda --size=2048
part pv.1040 --fstype="lvmpv" --ondisk=sda --grow
volgroup gigatron --pesize=4096 pv.1040

%packages
@^minimal
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
