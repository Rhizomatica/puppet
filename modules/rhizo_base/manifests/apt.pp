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
  class { '::apt': }
#  apt::ppa { 'ppa:keithw/mosh': }
#  apt::ppa { 'ppa:ondrej/php5': }


  apt::source { 'freeswitch':
      location          => 'http://files.freeswitch.org/repo/deb/freeswitch-1.6/',
      release           => 'jessie',
      repos             => 'main',
      include_src       => false,
      key_source        => 'http://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub'
    }

  file { '/etc/apt/apt.conf.d/90unsigned':
      ensure  => present,
      content => 'APT::Get::AllowUnauthenticated "true";',
    }

  apt::source { 'rhizomatica':
      location          => 'http://dev.rhizomatica.org/ubuntu/',
      release           => 'precise',
      repos             => 'main',
      include_src       => false,
      require           => File['/etc/apt/apt.conf.d/90unsigned'],
    }

  apt::source { 'rhizorepo':
      location          => 'http://repo.rhizomatica.org/ubuntu/',
      release           => 'precise',
      repos             => 'main',
      include_src       => false,
      require           => File['/etc/apt/apt.conf.d/90unsigned'],
    }    
/*
  apt::source { 'icinga':
      location    => 'https://packages.icinga.org/ubuntu',
      release     => 'icinga-precise',
      repos       => 'main',
      key_source  => 'https://packages.icinga.org/icinga.key',
      include_src => false,
    }
*/
  apt::source { 'nodesource':
      location    => 'https://deb.nodesource.com/node_0.10',
      release     => 'jessie',
      repos       => 'main',
      key_source  => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
    }


  }
