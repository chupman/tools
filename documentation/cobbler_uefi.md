# Creating an Ubuntu 16.04 uefi profile in cobbler

Preface: This guide does not cover basic cobbler installation or configuration
1.	To start I made a copy of my normal Ubuntu 16.04 install

`cobbler profile copy --name=Ubuntu-16.04-x86_64 --newname=Ubuntu-16.04-x86_64-efi`

![copy profile](images/copy_profile.jpg)

2. Once we have a new profile to work with we can create a copy of the seed file to work with.

`cp /var/lib/cobbler/kickstarts/sample.seed /var/lib/cobbler/kickstarts/uefi.seed`

  Then set it as the seed file for the profile

`cobbler profile edit --name=Ubuntu-16.04-x86_64-efi kickstart=/var/lib/cobbler/kickstarts/uefi.seed`

![copy profile](images/set_seedfile.jpg)

By default the sample.seed has a 1-2 lines that need to be updated. If you have a local repo setup 
you can leave "d-i mirror/http/hostname string $http_server" as is, but you'll still need to set the 
path for "d-i mirror/http/directory string" since at least as of version 2.8 $install_source_directory 
isn't a valid variable and doesn't evaluate into a real path. The default path is /cobbler/ks_mirror/<dist name>
You can hardcode the value of the path, btu I reccommend using $distro_name so that you can reuse the preseed file
for multiple distributions. Also it's always a good idea to pop the url into your browser and make sure the path
actually exists.
`
d-i mirror/http/hostname string $http_server
# d-i mirror/http/directory string $install_source_directory
d-i mirror/http/directory string /cobbler/ks_mirror/$distro_name/
`


For Partitioning we're going to need to use preseed_early command to setup our disks for us. In the 
sample.seed there's already a line calling /var/lib/cobbler/scripts/preseed_early_default. We want to
make a copy of that file and add our partitioning scheme there.
`cp /var/lib/cobbler/scripts/preseed_early_default /var/lib/cobbler/scripts/preseed_early_Ubuntu16.04-efi`

Then we'll want to change the following line in our profile preseed file /var/lib/cobbler/kickstarts/uefi.seed
`
d-i preseed/early_command string wget -O- \
   http://$http_server/cblr/svc/op/script/$what/$name/?script=preseed_early_default | \
   /bin/sh -s
`
to
`
d-i preseed/early_command string wget -O- \
   http://$http_server/cblr/svc/op/script/$what/$name/?script=preseed_early_Ubuntu16.04-efi | \
   /bin/sh -s
`

`
d-i partman/early_command \
if [ -d "/sys/firmware/efi/" ]; then
    debconf-set "partman-auto/expert_recipe" "$(
        echo -n '600 600 1075 free $iflabel{ gpt } $reusemethod{ } method{ efi } format{ } . '
        echo -n '128 512 256 ext2 $defaultignore{ } method{ format } format{ } use_filesystem{ } filesystem{ ext2 } mountpoint{ /boot } . '
        echo -n '9216 2000 -1 $default_filesystem $lvmok{ } method{ format } format{ } use_filesystem{ } $default_filesystem{ } mountpoint{ / } .'
    )"
fi
`