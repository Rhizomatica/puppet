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
      ensure             => directory,
      source             => 'puppet:///modules/rhizo_base/etc/sv',
      source_permissions => use,
      recurse            => remote,
      require => Class['rhizo_base::packages'],
    }

#  file { '/etc/service/osmo-nitb':
#      ensure  => link,
#      target  => '/etc/sv/osmo-nitb',
#      require =>
#        [ File['/etc/sv'], Class['rhizo_base::openbsc'] ],
#    }

  if $operatingsystem != 'Debian' {
    file { '/etc/service/freeswitch':
        ensure  => link,
        target  => '/etc/sv/freeswitch',
        require =>
          [ File['/etc/sv'], Class['rhizo_base::freeswitch'] ],
      }
  }

  file { '/etc/service/rapi':
      ensure  => link,
      target  => '/etc/sv/rapi',
      require => File['/etc/sv'],
    }

  file { '/etc/service/smpp':
      ensure  => link,
      target  => '/etc/sv/smpp',
      require => [ File['/etc/sv'] ],
    }

  file { '/etc/service/esme':
      ensure  => link,
      target  => '/etc/sv/esme',
      require => [ File['/etc/sv'] ],
    }

  file { '/etc/service/lcr':
      ensure  => false,
      target  => '/etc/sv/lcr',
      require => [ File['/etc/sv'], Class['rhizo_base::lcr'] ],
    }

  file { '/etc/service/osmo-sip-connector':
      ensure  => link,
      target  => '/etc/sv/osmo-sip-connector',
      require => [ File['/etc/sv'] ],
    }

  file { '/etc/service/kiwi':
      ensure  => link,
      target  => '/etc/sv/kiwi',
      require => [ File['/etc/sv'], Class['rhizo_base::kiwi'] ],
    }

  file { '/etc/service/meas-web':
       ensure  => link,
       target  => '/etc/sv/meas-web',
       require => [ File['/etc/sv'], Package['websocketd'] ],
    }

  }
