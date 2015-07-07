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

  package { ['osmocom-nitb', 'osmocom-nitb-dbg',
  'libdbd-sqlite3', 'libsmpp0']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
      notify  => Exec['hlr_pragma_wal'],
    }

  service { 'osmocom-nitb':
      enable  => false,
      require => Package['osmocom-nitb']
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
  }
