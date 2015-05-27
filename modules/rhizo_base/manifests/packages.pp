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
            'libffi-dev']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  package { 'puppet':
      ensure  => '3.7.5-1puppetlabs1',
    }

  }