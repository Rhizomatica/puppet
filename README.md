# Rhizomatica Puppet repository

Here you will find all the modules which we are currently using in the Rhizomatica infrastructure.
Some of them are directly pulled from [PuppetForge](https://forge.puppetlabs.com) or [github](https://github.com). A bunch are included as submodules, others are directly imported in the repository.
To have a working repo, you should also include all the submodules:

    git submodule init
    git submodule update

To have a fully configured system from scratch, these are the steps:

1 - Install `Ubuntu 12.04, 64-bit version`. There is a preseed file included in this git repo which can make it easier and faster `:)`

2 - Create a new user, called `rhizomatica`. This is not needed if you have used the preseed file to do the install.

3 - Install `openvpn`, `openssh-server` and `puppet`:
       
    sudo apt-get install openvpn openssh-server puppet

4 - Configure the VPN - normally just a matter of unpacking the config and keys in `/etc/openvpn` and restarting `openvpn`

5 - Edit `/etc/puppet/puppet.conf` and add the proper puppet server

6 - Run puppet for the first time:

    puppet agent --test

This will generate the key and certificate

7 - Connect to the VPN/Puppet server, check the certificates:

    puppet ca list

And sign the one you just generated in the step above:

    puppet ca sign <hostname>

8 - *On the VPN/Puppet server* Personalize the hiera file which is going to describe your installation by copying over the template file to something like `<hostname>.yaml` in `/etc/puppet/hieradata`, where `hostname` is the name for the host you are currently configuring.

9 - Run puppet again:

    puppet agent --test

10 - Profit! `:D`
