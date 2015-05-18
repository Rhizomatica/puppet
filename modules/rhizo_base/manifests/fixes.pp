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
#FSCK at boot
  file { '/etc/default/rcS':
      ensure  => present,
      source  => 'puppet:///modules/rhizomatica_base_system/etc/default/rcS',
    }

#Grub fix
  file { '/etc/default/grub':
      ensure  => present,
      source  => 'puppet:///modules/rhizomatica_base_system/etc/default/grub',
      notify  => Exec['update-grub'],
    }

  exec { 'update-grub':
      command     => '/usr/sbin/update-grub',
      refreshonly => true,
    }
  }
