# Class: rhizo_base::openbsc
#
# This module manages the OpenBSC system
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::openbsc {
  $network_name    = $rhizo_base::network_name
  $auth_policy     = $rhizo_base::auth_policy
  $max_power_red   = $rhizo_base::max_power_red
  $arfcn_A         = $rhizo_base::arfcn_A
  $arfcn_B         = $rhizo_base::arfcn_B
  $arfcn_C         = $rhizo_base::arfcn_C
  $arfcn_D         = $rhizo_base::arfcn_D
  $arfcn_E         = $rhizo_base::arfcn_E
  $arfcn_F         = $rhizo_base::arfcn_F
  $bts2_ip_address = $rhizo_base::bts2_ip_address
  $bts3_ip_address = $rhizo_base::bts3_ip_address
  $smsc_password   = $rhizo_base::smsc_password

  package { [ 'libosmoabis4', 'libosmocore6',
              'libosmoctrl0', 'libosmogsm5',
              'libosmovty1', 'osmocom-nitb',
              'osmocom-nitb-dbg']:
      ensure   => latest,
      require  => Class['rhizo_base::apt'],
      notify   => [ Exec['hlr_pragma_wal'],
                    Exec['restart-nitb'] ],
    }

  package { [ 'libosmoabis3', 'libosmocore4',
              'libosmogsm6', 'libosmovty0',
              'libgtp', 'libgtp0',
              'libgtp0-dev', 'openggsn',
              'libosmo-abis', 'libosmo-abis-dbg',
              'libosmo-abis-dev', 'libosmo-netif-dbg',
              'libosmo-netif-dev', 'libosmo-sccp',
              'libosmo-sccp-dbg', 'libosmo-sccp-dev',
              'libosmocodec0', 'libosmocore',
              'libosmocore-dbg', 'libosmocore-dev',
              'libosmocore-utils', 'libosmogb3',
              'libosmonetif2', 'libosmosim0',
              'libosmotrau0']:
      ensure => purged,
  }

  service { 'osmocom-nitb':
      enable  => false,
      require => Package['osmocom-nitb'],
    }

  file { '/etc/osmocom/osmo-nitb.cfg':
      content => template('rhizo_base/osmo-nitb.cfg.erb'),
      require => Package['osmocom-nitb'],
    }

  exec { 'hlr_pragma_wal':
      command     =>
        '/usr/bin/sqlite3 /var/lib/osmocom/hlr.sqlite3 "PRAGMA journal_mode=wal;"',
      require     => Class['rhizo_base::packages'],
      refreshonly => true,
    }

  exec { 'restart-nitb':
      command     => '/usr/bin/sv restart osmo-nitb',
      require     => Class['rhizo_base::packages'],
      refreshonly => true,
    }

  }
