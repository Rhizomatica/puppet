# Rhizomatica Puppet repository

This is a puppet recipe to install and prepare an installation of RCCN on a Debian 9 system.

**INSTALLATION:** 

Install Debian 9 (stretch) amd64 from 
[https://www.debian.org/distrib/netinst](https://www.debian.org/distrib/netinst)

- During the Install process, create a user '**rhizomatica**'
- Partition as you please, otherwise "**Guided - use entire disk**"
- As above, otherwise "**All files in one partition**" is fine.
- Setup a minimal system. You don't need a **desktop environment**.
 I suggest you install **SSH server** and **standard system utilities**.
- Boot into the new system, login, locally or via ssh.
- Get root with `su -` if needed and run the following:


`root@host~# apt-get install git puppet puppetmaster` 

(Accept all the additional packages)

`root@host:~# cd /etc/puppet/code`

`root@host:/etc/puppet/code# mkdir environments`

`root@host:/etc/puppet/code# mkdir hiera`

`root@host:/etc/puppet/code# cd environments`

`root@host:/etc/puppet/code/environments# git clone https://github.com/Rhizomatica/puppet.git production`

`root@host:/etc/puppet/code/environments# cd prodution`

`root@host:/etc/puppet/code/environments/production# git submodule init`

`root@host:/etc/puppet/code/environments/production# git submodule update`

`root@host:/etc/puppet/code/environments/production# cp hiera.yaml /etc/puppet`

`root@host:/etc/puppet/code/environments/production# cp hieradata/* /etc/puppet/code/hiera`

`root@host:/etc/puppet/code/environments/production# cd /etc/puppet/code/hiera`

`root@host:/etc/puppet/code/hiera# cp site_template.yaml $(hostname -f | awk '{print tolower($0)}').yaml`

`root@host:/etc/puppet/code/hiera# cd`

`root@host:~# echo "127.0.0.1 puppet" >> /etc/hosts`

`root@host:~# systemctl restart puppetmaster`

You are now ready to run the puppet agent to prepare and configure your system.


**CAVEAT:** FreeSwitch 1.6 is not fully supported yet on Debian 9, but the only problem is a dependency on libssl1.0.0, which is not packaged for Debian 9, so you only need to do the following by hand first: Don't forget, or freeswitch will not install.

```
wget http://security-cdn.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0-dbg_1.0.1t-1+deb8u12_amd64.deb
dpkg -i libssl1.0.0-dbg_1.0.1t-1+deb8u12_amd64.deb
rm libssl1.0.0-dbg_1.0.1t-1+deb8u12_amd64.deb
```

Now we can install :-)
We use ignoreschedules here to make sure that everything happens on these
initial runs, you should not need it afterwards. 

`root@host:~# puppet agent --test --ignoreschedules`

This may take a while, it has to fetch all the packages and install them,
Some package installations will fail, so when it is finished you need to do it once more:

`root@host:~# puppet agent --test --ignoreschedules`

Done! Now you can run the final RCCN setup step, but before you do this,
take a quick look at CAVEATS below.:

`root@host:~# cd /var/rhizomatica/rccn`

`root@host:/var/rhizomatica/rccn# python ./install.py -f`

Now reboot your system and [file a bug report](https://github.com/Rhizomatica/puppet/issues/new) about whatever is still not working.

### Thanks for testing RCCN! ###


----------



**CAVEATS:**

- Because you don't have the key to our private repo, you will not have any sounds in `/usr/share/freeswitch/sounds/rccn/`.
TIC is not publically distributing the sound files used on the TIC network. Someone needs to make some generic sounds.

- You might want to do `systemctl restart osmo-nitb` before running the
install.py, as if the NITB has never run, the sqlite HLR database will not
exist yet. - What's more, systemd is not starting the NITB on reboot. You
need to do `systemctl start osmo-nitb` manually. :-/
Same goes for freeswitch. FIXES??

- After install and reboot, considering add the user rhizomatica to the sudo group: `usermod -aG sudo rhizomatica`

- After install, you do not really need the puppet master service running, so
consider disabling it.

----------



