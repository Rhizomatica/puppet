# Rhizomatica Puppet repository

This is a puppet recipe to install and prepare an installation of RCCN on a Debian 9 system.

This is earmarked to be the future default install. For now it probably does not work for you.

Please see the README in the master branch of this repo.

There is one thing you need to do by hand first:

```
wget http://http.debian.net/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1%2bdeb8u7_amd64.deb
dpkg -i libssl1.0.0_1.0.1t-1+deb8u7_amd64.deb 
```


There is one error:

```
Error: /Stage[main]/Postgresql::Server::Config/Concat[/etc/postgresql/9.6/main/pg_hba.conf]/Concat_file[/etc/postgresql/9.6/main/pg_hba.conf]: Failed to generate additional resources using 'eval_generate': comparison of Array with Array failed
```


