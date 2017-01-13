# Rhizomatica Puppet repository

Here you will find the puppet recipe that we use to configure and maintain all our nodes in the Oaxaca Network run by TIC A.C.

We use one internal puppet master server for our cluster of nodes, but one can alternatively install on a single machine by configuring and running the puppet master and then letting the puppet agent set everything up for you, all on the same machine. If you are using one machine, simply ignore the instructions below where you are directed to change from client to puppet server.

To do this, you need to:

  **1** - Choose an Operating System. Historically, we began with Ubuntu 12.04 LTS. Support for Ubuntu 12.04 ends in April 2017. 

  Install `Ubuntu 12.04, 14.04 or Debian 8, 64-bit version`. There is a preseed file included in this git repo which can make it easier and faster `:)` Not tested on 14.04.

  **2** - Create a new user, called `rhizomatica`. This is not needed if you have used the preseed file to do the install.

  **3** - Install `openvpn`, `openssh-server` and `puppet`:
       
    sudo apt-get install openvpn openssh-server puppet

  **4** - Clone this repo into /etc/puppet/environments/[ENVIRONMENT_NAME]

 The default environment name in puppet is 'production'. It is suggested to use it, therefore *on the Puppet server*, do:
	
	cd /etc/puppet/environments
	git clone https://github.com/Rhizomatica/puppet.git production

  This repo contains all the modules which we are currently using in the Rhizomatica infrastructure. Some of them are directly pulled from [PuppetForge](https://forge.puppetlabs.com) or [github](https://github.com). A bunch are included as submodules, others are directly imported in the repository.

To have a working repo, you must also include all the submodules, so do:

    git submodule init
    git submodule update

To have a fully configured system from scratch, these are the steps:

  [ FIXME: At the time of writing Ubuntu 12.04 LTS is the version supported here by the master branch, but only for existing installs. New installs will fail because of upstream changes. ] If you wish to install on Ubuntu 12.04, you will need to 

	cd /etc/puppet/environments/[ENVIRONMENT_NAME]
	git checkout whyteks/ubuntu12

  To install on Debian 8, do 

    git checkout whyteks/debian

  [ FIXME: If you want to install on Ubuntu 14.04 you may have to fix some stuff manually. ]

  **5** - Edit `/etc/puppet/puppet.conf` and add the puppet server. The default puppet server is 'puppet' so if you are running puppet master and puppet agent on the same box, you can alternatively point 'puppet' to 127.0.0.1 in /etc/hosts:

    127.0.0.1       puppet

  **6** - *On the Puppet server* Personalize the hiera file which is going to describe your installation by copying over the template file `hieradata/site_template.yaml` to `<hostname>.yaml` in `/etc/puppet/hieradata`, where `hostname` is the name for the host you are currently configuring.


  **7** - Run puppet for the first time:

    puppet agent --test

  This will generate the key and certificate

  **8** - *Connect to the Puppet server*, check the certificates:

    puppet ca list

  And sign the one you just generated in the step above:

    puppet ca sign <hostname>


  **9** - Run puppet again on the client:

    puppet agent --test

  **10** - Wait and observe, or not, as you wish. :) Depending on the speed of your internet connection some things might take some time. The puppet recipe is still not perfect and may fail due to dependencies on this second run. If this happens, goto step 9 until the puppet run completes cleanly.   

  **11** - You should now be running the complete Rhizomatica ecosystem. Principally, The Osmo Network-in-the-Box, Freeswitch, kannel, and all the glue inbetween. You should also see the web interface to administer your mobile network at `http://localhost/rai`

  **12** Probably it doesn't quite work yet, because there are some minor configuration steps to be completed. See further (work in progress) documentation on the [Rhizomatica Wiki](https://wiki.rhizomatica.org/index.php/Setting_up_the_BSC) or open an issue! 