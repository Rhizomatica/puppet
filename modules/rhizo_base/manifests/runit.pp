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

  $use_kannel = $rhizo_base::use_kannel

  file { '/etc/sv':
      ensure  => directory,
      source  => 'puppet:///modules/rhizo_base/etc/sv',
      recurse => remote,
      require => Class['rhizo_base::packages'],
    }

  if $use_kannel == 'yes' {

    file { '/etc/sv/osmo-nitb/run':
        ensure  => present,
        source  => 'puppet:///modules/rhizo_base/osmo-nitb.run.kannel',
        require => File['/etc/sv'],
      }

    service { 'kannel':
        enable  => true,
        require => Package['kannel'],
        notify => [ Exec['stop-esme'], Exec['start-kannel'] ],
      }
  }

  if $use_kannel == 'no' {

    file { '/etc/sv/osmo-nitb/run':
        ensure  => present,
        source  => 'puppet:///modules/rhizo_base/osmo-nitb.run',
        require => File['/etc/sv'],
      }

    file { '/etc/service/esme':
        ensure  => link,
        target  => '/etc/sv/esme',
        require => File['/etc/sv'],
        notify => [ Exec['stop-kannel'], Exec['start-esme'] ],
      }

    exec { 'disable-kannel':
        notify  => Exec['stop-kannel'],
        command => '/usr/sbin/update-rc.d kannel disable',
        require => Package['kannel'],
      }
  }

  file { '/etc/service/osmo-nitb':
      ensure  => link,
      target  => '/etc/sv/osmo-nitb',
      require =>
        [ File['/etc/sv'], Class['rhizo_base::openbsc'] ],
    }

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

  file { '/etc/service/meas-web':
      ensure  => link,
      target  => '/etc/sv/meas-web',
      require => [ File['/etc/sv'], Package['websocketd'] ],
    }

  exec { 'start-esme':
      command     => '/usr/bin/sv start esme',
      refreshonly => true,
    }

  exec { 'stop-esme':
      command     => '/usr/bin/sv stop esme',
      refreshonly => true,
    }

  exec { 'start-kannel':
      command     => '/etc/init.d/kannel start',
      refreshonly => true,
    }

  exec { 'stop-kannel':
      command     => '/etc/init.d/kannel stop',
      refreshonly => true,
    }
  }
