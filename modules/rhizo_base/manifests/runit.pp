# Class: rhizo_base::runit
#
# This module manages the Runit startup scripts
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::runit {
  file { '/etc/sv':
      ensure  => directory,
      source  => 'puppet:///modules/rhizo_base/etc/sv',
      recurse => remote,
      require => Class['rhizo_base::packages'],
    }

  file { '/etc/service/osmo-nitb':
      ensure  => link,
      target  => '/etc/sv/osmo-nitb',
      require =>
        [ File['/etc/sv'], Class['rhizo_base::openbsc'] ],
    }

  file { '/etc/service/freeswitch':
      ensure  => link,
      target  => '/etc/sv/freeswitch',
      require =>
        [ File['/etc/sv'], Class['rhizo_base::freeswitch'] ],
    }

  file { '/etc/service/rapi':
      ensure  => link,
      target  => '/etc/sv/rapi',
      require => File['/etc/sv'],
    }

  file { '/etc/service/lcr':
      ensure  => link,
      target  => '/etc/sv/lcr',
      require => [ File['/etc/sv'], Class['rhizo_base::lcr'] ],
    }

  file { '/etc/service/kiwi':
      ensure  => link,
      target  => '/etc/sv/kiwi',
      require => [ File['/etc/sv'], Class['rhizo_base::kiwi'] ],
    }

  }