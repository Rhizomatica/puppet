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
  apt::ppa { 'ppa:keithw/mosh': }
  apt::ppa { 'ppa:ondrej/php5': }
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
  apt::source { 'icinga':
      location    => 'http://packages.icinga.org/ubuntu',
      release     => 'icinga-precise',
      repos       => 'main',
      key         => 'C6E319C334410682',
      key_server  => 'subkeys.pgp.net',
      include_src => false,
    }

  }