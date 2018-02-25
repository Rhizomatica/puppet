# Class: rhizo_base::packages
#
# This module manages the packages not included in other modules
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::packages {
  include "rhizo_base::packages::$operatingsystem"
}

class rhizo_base::packages::common {

  package { ['mosh', 'git', 'openvpn', 'lm-sensors', 'runit-systemd', 'sqlite3',
            'libffi-dev', 'apcupsd', 'expect', 'gawk', 'swig', 'g++', 'tinc', 'tcpdump',
            'libcdk5' , 'sngrep', 'rrdtool', 'dnsmasq', 'joe', 'curl', 'htop', 'screen',
            'python-unidecode', 'python-dateutil', 'python-yaml', 'python-formencode',
            'python-smpplib', 'python-psycopg2', 'python-pysqlite2' ]:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }
}

class rhizo_base::packages::ubuntu inherits rhizo_base::packages::common {

  package { ['puppet', 'puppet-common']:
      ensure  => '3.8.1-1puppetlabs1',
    }

#Apache2 + PHP
  package { ['apache2','libapache2-mod-php5.6', 'php5.6', 'php5.6-pgsql',
  'php5.6-curl', 'php5.6-cli', 'php5.6-gd', 'php5.6-xml',
  'python-corepost', 'python-twisted-web' ]:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  file { '/etc/php/5.6/apache2/php.ini':
      ensure  => present,
      source  => "puppet:///modules/rhizo_base/etc/php5/apache2/php.ini.$operatingsystem"
    }


}

class rhizo_base::packages::debian inherits rhizo_base::packages::common {

  package { ['apache2','libapache2-mod-php', 'php', 'php-pgsql',
  'php-curl', 'php-cli', 'php-gd',
  'sudo', 'apt-transport-https']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  file { '/etc/php/7.0/apache2/php.ini':
      ensure  => present,
      source  => "puppet:///modules/rhizo_base/php.ini",
      notify  => Exec['restart-apache']
    }

}
