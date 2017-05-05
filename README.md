# Rhizomatica Puppet repository

Here you will find the puppet recipe that we use to configure and maintain all our nodes in the Oaxaca Network run by TIC A.C.

We use one internal puppet master server for our cluster of nodes, but one can alternatively install on a single machine by configuring and running the puppet master and then letting the puppet agent set everything up for you, all on the same machine. If you are using one machine, simply ignore the instructions below where you are directed to change from client to puppet master.

To do this, you need to:

  **1** - Choose an Operating System. Historically, we began with Ubuntu 12.04 LTS. Upstream support for Ubuntu 12.04 ends in April 2017. 

  Install `Ubuntu 12.04, 14.04 or Debian 8, 64-bit version`. There is a preseed file included in this git repo which can make it easier and faster `:)` Not tested on 14.04/Debian.

  **2** - Create a new user, called `rhizomatica`. This is not needed if you have used the preseed file to do the install.

  **3** - Install  `openssh-server`, `git` and `puppet`:

We install puppet from the puppetlabs repo, so depending on your OS choice, do something like:

	wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
    OR
	wget https://apt.puppetlabs.com/puppetlabs-release-jessie.deb

Install the package you just downloaded. (This just installs the puppet labs repo)

	sudo dpkg -i puppetlabs-release-[whatever].deb

Now, update your apt repositories

	sudo apt-get update

Install:

	sudo apt-get install openssh-server git puppet

If you are going to run your own local puppet master:

	sudo apt-get install puppetmaster

  **4** - ON MASTER: We'll put this recipe in its own enviroment, so do the following:

    cd /etc/puppet
    mkdir environments
    mkdir hieradata

 Then you need to add the following lines to the [main] section of your /etc/puppet/puppet.conf:

    environmentpath=$confdir/environments
    modulepath=/etc/puppet/environments/$environment/modules:/etc/puppet/modules
 
 In order to support the syntax of some submodules we use, you also need to add this line to the [master] section of /etc/puppet/puppet.conf:

    parser=future

  Clone this repo into /etc/puppet/environments/[ENVIRONMENT_NAME]

  The default environment name in puppet is 'production'. It is suggested to use it, therefore *on the Puppet server*, do:
	
	cd /etc/puppet/environments
	git clone https://github.com/Rhizomatica/puppet.git production


  This repo contains all the modules which we are currently using in the Rhizomatica infrastructure. Some of them are directly pulled from [PuppetForge](https://forge.puppetlabs.com) or [github](https://github.com). A bunch are included as submodules, others are directly imported in the repository.

To have a working puppet recipe, you must also include all the submodules, so then do:

	cd production
    git submodule init
    git submodule update


  **5** - ON CLIENT: Edit `/etc/puppet/puppet.conf` and add the puppet server. The default puppet server name is 'puppet' so if you are running puppet master and puppet agent on the same box, you can alternatively point 'puppet' to 127.0.0.1 in /etc/hosts:

    127.0.0.1       puppet

  **6** - ON MASTER: Copy the file `hiera.yaml` from `/etc/puppet/environments/production/` to `/etc/puppet/hiera.yaml`. 

  Copy the defaults from `/etc/puppet/environments/production/hieradata/*` to `/etc/puppet/hieradata/`. 

  Personalize the hiera file which is going to describe your installation by copying over the template file `site_template.yaml` to `<hostname>.yaml` in `/etc/puppet/hieradata`, where `hostname` is the name for the host you are currently configuring. 


  **7** - ON CLIENT: Run puppet for the first time:

    puppet agent --test

  This will generate the key and certificate

  **8** - ON MASTER:, check the certificates:

    puppet ca list

  And sign the one you just generated in the step above:

    puppet ca sign <hostname>


  **9** - ON CLIENT: Run puppet again on the client:

    puppet agent --test

  **10** - Wait and observe, or not, as you wish. :) Depending on the speed of your internet connection some things might take some time. The puppet recipe is far from perfect and some things will fail due to dependencies on this run. When this happens, goto step 9 until the puppet run completes cleanly, without any errors in red text.

  **11** - You should now be running the complete Rhizomatica ecosystem. Principally, The Osmo Network-in-the-Box, Freeswitch, kannel, and all the glue inbetween. You should also see the web interface to administer your mobile network at `http://localhost/rai`

  **12** - It doesn't quite work yet, because there are some minor configuration steps to be completed. Namely, you need to run the script `/var/rhizomatica/rccn/install.py` to setup your database and a couple of other things. However, this will fail if puppet hasn't written the correct configuration because you haven't setup everything correctly in your hiera host file in step 6. 

[ FIXME: The `install.py` is not very intelligent and certainly not very forgiving *and* it expects to be running on a clean system. Once you run it on a b0rked config, it may complete some tasks and then will most likely fail if you try to run it again. ] 

!! Pull Requests are welcome!! See further (work in progress) documentation on the [Rhizomatica Wiki](https://wiki.rhizomatica.org/index.php/Setting_up_the_BSC) or open an issue! 
