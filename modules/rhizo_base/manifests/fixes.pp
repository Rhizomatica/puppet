# Class: rhizo_base::fixes
#
# This module manages various system fixes
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#

class rhizo_base::fixes {
  include "rhizo_base::fixes::$operatingsystem"

  file { '/etc/tmux.conf':
      ensure  => present,
      source  => 'puppet:///modules/rhizo_base/tmux.conf',
  }

}

class rhizo_base::fixes::ubuntu {
#FSCK at boot
  file { '/etc/default/rcS':
      ensure  => present,
      source  => 'puppet:///modules/rhizo_base/etc/default/rcS',
    }

#Grub fix
  file { '/etc/default/grub':
      ensure  => present,
      source  => 'puppet:///modules/rhizo_base/etc/default/grub',
      notify  => Exec['update-grub'],
    }

  exec { 'update-grub':
      command     => '/usr/sbin/update-grub',
      refreshonly => true,
    }
}

class rhizo_base::fixes::debian {
  # Nothing
}