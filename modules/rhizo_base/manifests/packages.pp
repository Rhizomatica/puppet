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

  package { ['mosh', 'git', 'openvpn', 'lm-sensors', 'runit', 'sqlite3',
            'libffi-dev', 'apcupsd', 'expect', 'gawk', 'swig', 'g++',
            'python-python-smpplib', 'libcdk5' ]:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

}

class rhizo_base::packages::ubuntu inherits rhizo_base::packages::common {

  package { ['puppet', 'puppet-common']:
      ensure  => '3.8.1-1puppetlabs1',
    }

#Apache2 + PHP + Python
  package { ['apache2','libapache2-mod-php5.6',
  'rrdtool', 'python-twisted-web', 'python-psycopg2',
  'python-pysqlite2', 'php5.6', 'php5.6-pgsql',
  'php5.6-curl', 'php5.6-cli', 'php5.6-gd', 'python-corepost',
  'python-yaml', 'python-formencode', 'python-unidecode',
  'python-dateutil']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  file { '/etc/php/5.6/apache2/php.ini':
      ensure  => present,
      source  => "puppet:///modules/rhizo_base/etc/php5/apache2/php.ini.$operatingsystem"
    }


}

class rhizo_base::packages::debian inherits rhizo_base::packages::common {

  package { ['apache2','libapache2-mod-php5',
  'rrdtool', 'python-psycopg2',
  'python-pysqlite2', 'php5', 'php5-pgsql',
  'php5-curl', 'php5-cli', 'php5-gd',
  'python-yaml', 'python-formencode', 'python-unidecode',
  'python-dateutil', 'sudo', 'apt-transport-https']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  file { '/etc/php5/apache2/php.ini':
      ensure  => present,
      source  => "puppet:///modules/rhizo_base/etc/php5/apache2/php.ini.$operatingsystem"
    }


}