# Class: rhizo_base::lcr
#
# This module manages the LCR system
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::lcr {
  package { 'lcr':
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  file { '/usr/etc/lcr':
      ensure  => directory,
      source  => 'puppet:///modules/rhizo_base/usr/etc/lcr',
      recurse => remote,
      purge   => true,
      require => Package['lcr'],
    }

  file { '/etc/default/lcr':
      ensure  => present,
      source  => 'puppet:///modules/rhizo_base/etc/default/lcr',
      require => Package['lcr'],
    }

  }