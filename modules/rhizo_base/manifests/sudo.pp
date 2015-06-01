# Class: rhizo_base::sudo
#
# This module manages the sudo package
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::sudo {

  file { '/etc/sudoers':
      ensure  => present,
      source  => 'puppet:///modules/rhizo_base/etc/sudoers',
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
    }
  }
