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
  contain "rhizo_base::packages::$lsbdistcodename"
}

class rhizo_base::packages::common {

  include stdlib

  package { ['apache2','libapache2-mod-php', 'php', 'php-pgsql',
             'php-curl', 'php-cli', 'php-gd', 'php-intl', 'php-gettext',
             'sudo']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
  }

  package { ['mosh', 'tmux', 'git', 'openvpn', 'lm-sensors', 'runit-systemd', 'sqlite3',
            'libffi-dev', 'apcupsd', 'expect', 'gawk', 'swig', 'g++', 'tinc', 'tcpdump',
            'sngrep', 'rrdtool', 'dnsmasq', 'joe', 'curl', 'htop', 'screen',
            'websocketd', 'fping', 'mtr-tiny', 'openssh-server', 'telnet', 'netcat-traditional',
            'python-unidecode', 'python-dateutil', 'python-yaml', 'python-formencode',
            'python-smpplib', 'python-psycopg2', 'python-pysqlite2' ]:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }
}

class rhizo_base::packages::buster inherits rhizo_base::packages::common {

  package { ['libcdk5nc6' ]:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  # FIXME: An Apache restart is required after this change.
  file_line { 'apache_php':
    ensure             => present,
    path               => '/etc/php/7.3/apache2/php.ini',
    line               => 'short_open_tag = On',
    match              => '^short_open_tag',
    append_on_no_match => false,
  }

}

class rhizo_base::packages::stretch inherits rhizo_base::packages::common {

  package { ['libcdk5' ]:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  file { '/etc/php/7.0/apache2/php.ini':
      ensure  => present,
      source  => "puppet:///modules/rhizo_base/php.ini",
      require => Package['libapache2-mod-php']
    }

}
