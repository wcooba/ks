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
network  --bootproto=static --device=enp0s3 --gateway=10.0.0.1 --ip=10.0.0.33 --nameserver=10.0.0.1,10.0.0.6 --netmask=255.255.255.0 --onboot=yes --noipv6
#network  --bootproto=dhcp --device=em2 --onboot=off --ipv6=auto
#network  --bootproto=dhcp --device=em3 --onboot=off --ipv6=auto
#network  --bootproto=dhcp --device=em4 --onboot=off --ipv6=auto
network  --hostname=gigatron-hv02.automaticamusments.local

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
