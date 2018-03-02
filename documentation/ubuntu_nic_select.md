#How to get Ubuntu to select a specific interface with multiple nics connected.

The package used to configure the network during build is netcfg. Netcfg has a
function called choose_interface that should allow you to provide an interface
name to bypass interface selection prompt, the unfortunate bit is that it doesn't
work. In order to have an interface selected you need to pass it as a kernel 
parameter. You should be able to pass the persistent interface name, such
as interface=enp22s0f0. For me this did not work