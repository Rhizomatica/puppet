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

  package { ['mosh', 'git', 'openvpn', 'lm-sensors', 'runit', 'sqlite3',
            'libffi-dev', 'apcupsd']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  package { ['puppet', 'puppet-common']:
      ensure  => '3.8.1-1puppetlabs1',
    }

#Apache2 + PHP + Python
  package { ['apache2','libapache2-mod-php5',
  'rrdtool', 'python-twisted-web', 'python-psycopg2',
  'python-pysqlite2', 'php5', 'php5-pgsql',
  'php5-curl', 'php5-cli', 'php5-gd', 'python-corepost',
  'python-yaml', 'python-formencode', 'python-unidecode',
  'python-dateutil']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  file { '/etc/php5/apache2/php.ini':
      ensure  => present,
      source  => 'puppet:///modules/rhizo_base/etc/php5/apache2/php.ini',
      require => Package['libapache2-mod-php5'],
    }

}
