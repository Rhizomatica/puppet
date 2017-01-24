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

  class { '::apt': }

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
  apt::source { 'rhizo':
      location          => 'http://repo.rhizomatica.org/ubuntu/',
      release           => 'precise',
      repos             => 'main',
      include_src       => false,
      require           => File['/etc/apt/apt.conf.d/90unsigned'],
    }

}

class rhizo_base::apt::ubuntu inherits rhizo_base::apt::common {

  apt::ppa { 'ppa:keithw/mosh': }
  apt::ppa { 'ppa:ondrej/php': }
  apt::ppa { 'ppa:ondrej/apache2': }

  apt::source { 'icinga':
      location    => 'https://packages.icinga.org/ubuntu',
      release     => 'icinga-precise',
      repos       => 'main',
      key_source  => 'https://packages.icinga.org/icinga.key',
      include_src => false,
    }

  apt::source { 'nodesource':
      location    => 'https://deb.nodesource.com/node_0.10',
      release     => 'precise',
      repos       => 'main',
      key_source  => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
    }
}

class rhizo_base::apt::debian inherits rhizo_base::apt::common {

  apt::source { 'freeswitch':
      location          => 'http://files.freeswitch.org/repo/deb/freeswitch-1.6/',
      release           => 'jessie',
      repos             => 'main',
      include_src       => false,
      key_source        => 'http://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub'
    }
    
  apt::source { 'nodesource':
      location    => 'https://deb.nodesource.com/node_0.10',
      release     => 'jessie',
      repos       => 'main',
      key_source  => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
    }
}
