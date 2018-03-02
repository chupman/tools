# Automatic interface selection with multiple nics in preseed

While you can't bypass the network selection screen simply by setting 
```d-i netcfg/choose_interface select <<interface name>>``` when you have multiple interfaces, you can bypass the menu with kernel paramters, namely ksdevice=<<bootif format mac address>> and interface=<<mac address | interface name>>. The question is how to pass these parameters in generalized, automated manner. Ubuntu lists examples of passing the ksdevice and bootif parameters at
https://help.ubuntu.com/community/KickstartCompatibility#Unsupported_Options, but doesn't include the interface paramter you'll need to fully bypass the prompt. 

By default cobbler will append kernel parameters that are set via the kopts flag. So on a system profile we can pass the mac address or interface name. You can also set the interface name on a profile level, but with predictable interface names you may need to create a separate profile for each hardware type. So if you have an extremely homogeneous environment, and like you us a console to select your operating system the profile level is a good option, otherwise I generally reccomend using scripts to create individual system profiles. I especially like this method because it easily enables the ability to add custom kickstart variables with ksmeta. Example script below that would read from a space delimited file with hostname, mac address, ip and interface name.
```
while read NAME MAC IP INT
do
cobbler system add --name=$NAME --interface=$INT --mac=$MAC --ip-address=$IP --netmask=255.255.254.0 --static=1 --dns-name=${NAME}.cloud.svl.ibm.com --profile=Ubuntu-16.04-x86_64-efi --gateway=9.30.210.1
#cobbler system edit --name=$NAME --in-place --ksmeta="bootdev=/dev/sde, clusterip=10.20.30.40"
cobbler system edit --name=$NAME --kopts="interface=${MAC}"
done < hostlist.file
```

The default settings in cobbler pass IPADDEND=2 so the system will know which interface to use based off the bootif parameter that is automatically set by IPAPPEND=2. Unfortunately you can't just set interface=bootif since the variable won't expand and instead will just try to bring up and interface named bootif. bootif provides the mac address in a very consumable format which would probably make it fairly straightforward to add support to the interface flag through the netcfg package, so who knows maybe it'll show up as a supported feature one day. 

```
[root@cobbler ~]$ cat /var/lib/tftpboot/pxelinux.cfg/01-90-e2-ba-2e-b0-70
default linux
prompt 0
timeout 1
label linux
        kernel /images/Ubuntu-16.04-x86_64/linux
        ipappend 2
        append initrd=/images/Ubuntu-16.04-x86_64/initrd.gz ksdevice=bootif lang=  interface=enp22s0f0 text  auto-install/enable=true priority=critical url=http://9.30.140.188/cblr/svc/op/ks/system/x3630m4001 hostname=x3630m4001 domain=local.lan suite=xenial
```

```
cobbler system edit --name=x3630m4002 --kopts="interface=90:e2:ba:2e:9b:1c"
cobbler system edit --name=x3630m4002 --kopts="interface=90:E2:BA:2E:9B:1C"
cobbler system edit --name=x3630m4002 --kopts="interface=enp22s0f0"
``` 

I can find the hosts tftp file in /var/lib/tftp/pxelinux.cfg/ the filename will be the hosts bootif parameter name os in my case 01-90-e2-ba-2e-9b-1c
```
default linux
prompt 0
timeout 1
label linux
        kernel /images/Ubuntu-16.04-x86_64/linux
        ipappend 2
        append initrd=/images/Ubuntu-16.04-x86_64/initrd.gz ksdevice=bootif lang=  interface=90:e2:ba:2e:9b:1c text  auto-install/enable=true priority=critical url=http://9.30.140.188/cblr/svc/op/ks/system/x3630m4002 hostname=x3630m4002 domain=local.lan suite=xenial
```



nic selection worked with interface name when a static IP was set, trying with auto next. auto worked with just interface set. 

d-i netcfg/link_wait_timeout string 10
d-i netcfg/choose_interface select auto
# d-i netcfg/get_ipaddress string 9.30.211.1
# d-i netcfg/get_netmask string 255.255.254.0
# d-i netcfg/get_gateway string 9.30.210.1
# d-i netcfg/get_nameservers string 9.30.140.185
# d-i netcfg/confirm_static boolean true
d-i netcfg/get_hostname string $myhostname