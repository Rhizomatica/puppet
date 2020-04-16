# Class: rhizo_base::apt
#
# This module manages the apt repositories
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#

class rhizo_base::apt {
  contain "rhizo_base::apt::$lsbdistcodename"
}

class rhizo_base::apt::common {

  $osmo_repo = hiera('rhizo::osmo_repo', 'latest')

  class { '::apt':
     update => {
       frequency => 'weekly',
     },
  }

  file { '/etc/apt/apt.conf.d/90unsigned':
      ensure  => present,
      content => 'APT::Get::AllowUnauthenticated "true";',
    }

  apt::source { 'rhizomatica':
      location          => 'http://dev.rhizomatica.org/ubuntu/',
      release           => 'precise',
      repos             => 'main',
      include  => {
        'src' => false,
        'deb' => true,
      },
      require           => File['/etc/apt/apt.conf.d/90unsigned'],
    }

  apt::source { 'rhizo':
      location          => 'http://repo.rhizomatica.org/ubuntu/',
      release           => 'precise',
      repos             => 'main',
      include  => {
        'src' => false,
        'deb' => true,
      },
      require           => File['/etc/apt/apt.conf.d/90unsigned'],
    }

  package { 'apt-transport-https':
      ensure  => installed,
    }
}

class rhizo_base::apt::buster inherits rhizo_base::apt::common {

  apt::source { 'freeswitch':
      location    => 'http://files.freeswitch.org/repo/deb/freeswitch-1.8/',
      release     => 'buster',
      repos       => 'main',
      key         => {
         'id'     => '20B06EE621AB150D40F6079FD76EDC7725E010CF',
         'source' => 'https://files.freeswitch.org/repo/deb/freeswitch-1.8/key.gpg'
       }
    }

  apt::source { 'nodesource':
      location    => 'https://deb.nodesource.com/node_0.10',
      release     => 'buster',
      repos       => 'main',
      key         => {
        'id'      => '9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280',
        'source'  => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
      },
      require     => Package['apt-transport-https'],
    }

  apt::source { 'irontec':
      location    => 'http://packages.irontec.com/debian',
      release     => 'buster',
      repos       => 'main',
      key         => {
        'id'      => '4FF7139B43073A436D8C2C4F90D20F5ED8C20040',
        'source'  => 'http://packages.irontec.com/public.key'
       }
    }

  apt::source { 'osmocom':
      location    => "http://download.opensuse.org/repositories/network:/osmocom:/${osmo_repo}/Debian_10.0/",
      release     => './',
      repos       => '',
      notify      => Exec['apt_update'],
      key         => {
        'id'      => '0080689BE757A876CB7DC26962EB1A0917280DDF',
        'source'  => "http://download.opensuse.org/repositories/network:/osmocom:/${osmo_repo}/Debian_10.0/Release.key"
       }
    }
}

class rhizo_base::apt::stretch inherits rhizo_base::apt::common {

  apt::source { 'freeswitch':
      location    => 'http://files.freeswitch.org/repo/deb/freeswitch-1.8/',
      release     => 'stretch',
      repos       => 'main',
      key         => {
         'id'     => '20B06EE621AB150D40F6079FD76EDC7725E010CF',
         'source' => 'https://files.freeswitch.org/repo/deb/freeswitch-1.8/key.gpg'
       }
    }

  apt::source { 'nodesource':
      location    => 'https://deb.nodesource.com/node_0.10',
      release     => 'jessie',
      repos       => 'main',
      key         => {
        'id'      => '9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280',
        'source'  => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
      },
      require     => Package['apt-transport-https'],
    }

  apt::source { 'irontec':
      location    => 'http://packages.irontec.com/debian',
      release     => 'stretch',
      repos       => 'main',
      key         => {
        'id'      => '4FF7139B43073A436D8C2C4F90D20F5ED8C20040',
        'source'  => 'http://packages.irontec.com/public.key'
       }
    }

  apt::source { 'rhizo-jessie':
      location    => 'http://repo.rhizomatica.org/debian/',
      release     => 'jessie',
      repos       => 'main',
      allow_unsigned => true,
      require     => File['/etc/apt/apt.conf.d/90unsigned'],
    }

  apt::source { 'osmocom':
      location    => "http://download.opensuse.org/repositories/network:/osmocom:/${osmo_repo}/Debian_9.0/",
      release     => './',
      repos       => '',
      notify      => Exec['apt_update'],
      key         => {
        'id'      => '0080689BE757A876CB7DC26962EB1A0917280DDF',
        'source'  => "http://download.opensuse.org/repositories/network:/osmocom:/${osmo_repo}/Debian_9.0/Release.key"
       }
    }

   file { [ '/etc/apt/sources.list.d/osmocom-latest.list',
            '/etc/apt/sources.list.d/osmocom-nightly.list' ]:
      ensure     => absent,
    }
}
