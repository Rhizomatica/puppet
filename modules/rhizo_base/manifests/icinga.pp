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
      ensure  => latest,
      require => Class['rhizo_base::apt'],
    }

  file { '/etc/icinga2/conf.d':
      ensure  => directory,
      source  => 'puppet:///modules/rhizo_base/etc/icinga2/conf.d',
      recurse => remote,
      require => Package['icinga2'],
      notify  => Exec['restart_icinga2'],
    }

  exec { 'restart_icinga2':
    command     => '/usr/sbin/service icinga2 restart',
    refreshonly => true,
    }

  }