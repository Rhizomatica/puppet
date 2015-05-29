# Class: rhizo_base::icinga
#
# This module manages Icinga2
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::icinga {

  package { ['icinga2', 'icinga2-bin', 'icinga2-common', 'icinga2-doc']:
      ensure  => '2.3.4~precise',
      require => Class['rhizo_base::apt'],
    }

  file { '/etc/icinga2/conf.d':
      ensure  => directory,
      source  => 'puppet:///modules/rhizo_base/etc/icinga2/conf.d',
      recurse => remote,
      require => Package['icinga2'],
    }

  }