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
  # TODO Switch to "contains" once puppet3 support is no longer required.
  include "rhizo_base::fixes::$operatingsystem"

  # Verbose anchor pattern used for legacy puppet support only.
  anchor { 'rhizo_base::fixes::first': } ->
  Class["rhizo_base::fixes::$operatingsystem"] ->
  anchor { 'rhizo_base::fixes::last': }

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
  file { '/root/.bashrc':
      ensure  => present,
      source  => 'puppet:///modules/rhizo_base/bashrc'
    }

  file { '/var/lib/puppet/state':
      ensure  => link,
      target  => '/var/cache/puppet/state/',
      force   => true,
    }
}
