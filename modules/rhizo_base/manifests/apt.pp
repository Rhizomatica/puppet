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
  include "rhizo_base::apt::$operatingsystem"
}

class rhizo_base::apt::common {

  class { '::apt':
     update => {
       frequency => 'daily',
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

}

class rhizo_base::apt::ubuntu inherits rhizo_base::apt::common {

  apt::ppa { 'ppa:keithw/mosh': }
  apt::ppa { 'ppa:ondrej/php': }
  apt::ppa { 'ppa:ondrej/apache2': }

  apt::source { 'nodesource':
      location    => 'https://deb.nodesource.com/node_0.10',
      release     => 'precise',
      repos       => 'main',
      key         => {
        'id'      => '68576280',
        'source'  => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
       } 
    }
}

class rhizo_base::apt::debian inherits rhizo_base::apt::common {

  apt::source { 'freeswitch':
      location          => 'http://files.freeswitch.org/repo/deb/freeswitch-1.6/',
      release           => 'jessie',
      repos             => 'main',
      key               => {
         'id'           => '25E010CF',
         'source'       => 'http://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub'
       }
    }
    
  apt::source { 'nodesource':
      location    => 'https://deb.nodesource.com/node_0.10',
      release     => 'jessie',
      repos       => 'main',
      key         => {
        'id'      => '68576280',
        'source'  => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
        }
    }

  apt::source { 'irontec':
      location    => 'http://packages.irontec.com/debian',
      release     => 'jessie',
      repos       => 'main',
      key         => {
        'id'      => 'D8C20040',
        'source'  => 'http://packages.irontec.com/public.key'
         }
    }

  apt::source { 'rhizo-jessie':
      location          => 'http://repo.rhizomatica.org/debian/',
      release           => 'jessie',
      repos             => 'main',
      require           => File['/etc/apt/apt.conf.d/90unsigned'],
    }    

  apt::source { 'osmocom-nightly':
      location          => 'http://download.opensuse.org/repositories/network:/osmocom:/nightly/Debian_9.0/',
      release           => './',
      repos             => '',
      key               => {
        'id'            => '17280DDF',
        'source'        => 'http://download.opensuse.org/repositories/network:/osmocom:/nightly/Debian_9.0/Release.key'
      }
    }
}
