# kickstart template for Fedora 8 and later.
# (includes %end blocks)
# do not use with earlier distros

# platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr --boot-drive=sdk --append="crashkernel=no rhgb quiet"
# Partition clearing information
# Use text mode install
text
# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone  America/Los_Angeles
# Install OS instead of upgrade
install
# Clear the Master Boot Record
# zerombr
# Allow anaconda to partition the system as needed
# autopart

ignoredisk --drives=sda,sdb,sdc,sdd,sde,sdf,sdg,sdh,sdi,sdj
###
clearpart --all --initlabel --drives=sdk
part biosboot --fstype=biosboot --size=1 --ondisk=sdk
part /boot/efi --fstype=vfat --size=200 --ondisk=sdk
part /boot --fstype ext3 --size=512 --ondisk=sdk --label=/boot
part pv.pv1 --size=1 --grow --ondisk=sdk
volgroup OS pv.pv1
logvol swap --fstype swap --name=swap --vgname=OS --size=16384
logvol / --fstype ext4 --name=root --vgname=OS --size=1 --grow --label=/


%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages
$SNIPPET('func_install_if_enabled')
%end

%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end

%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps
%end
