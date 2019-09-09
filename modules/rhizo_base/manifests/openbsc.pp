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

  include "rhizo_base::openbsc::$operatingsystem"

}

class rhizo_base::openbsc::ubuntu inherits rhizo_base::openbsc::common {

  package { [ 'libosmo-abis', 'libosmocore',
              'libosmocore-utils' ]:
      ensure   => latest,
      require  => Class['rhizo_base::apt'],
      notify   => [ Exec['notify-nitb'] ],
    }

  package {  [ 'osmocom-nitb', 'osmo-meas' ]:
      ensure   => 'latest',
      require  => [ Class['rhizo_base::apt'], Class['apt::update'] ],
      notify   => [ Exec['hlr_pragma_wal'],
                    Exec['notify-nitb'] ],
    }

  package { [ 'libosmoabis3', 'libosmocore8',
              'libosmogsm7', 'libosmovty3',
              'libgtp', 'libgtp0',
              'libgtp0-dev', 'openggsn',
              'libsmpp0',
              'libosmo-abis-dev',
              'libosmo-netif-dbg', 'libosmo-netif-dev' ]:
      ensure => purged,
      schedule => 'weekly',
  }

}

class rhizo_base::openbsc::debian inherits rhizo_base::openbsc::common {

  package { [ 'libosmocore' ]:
      ensure   => '1.1.0',
      schedule => 'weekly',
  }

  package {  [ 'osmocom-nitb' ]:
      ensure   => 'installed',
      require  => Class['rhizo_base::apt'],
      notify   => [ Exec['hlr_pragma_wal'],
                    Exec['notify-nitb'] ],
      schedule => 'weekly',
  }

  package { [ 'libosmocore-utils' ]:
      ensure   => installed,
      schedule => 'weekly',
  }

}

class rhizo_base::openbsc::common {

  $network_name    = $rhizo_base::network_name
  $auth_policy     = $rhizo_base::auth_policy
  $lac             = $rhizo_base::lac
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
  $gprs            = $rhizo_base::gprs
  $smpp_password   = $rhizo_base::smpp_password
  $mncc_codec      = $rhizo_base::mncc_codec


  if $mncc_codec == "AMR" {
       $phys_chan = "TCH/H"
  } else {
       $phys_chan = "TCH/F"
  }

  service { 'osmocom-nitb':
      enable  => false,
      require => Package['osmocom-nitb'],
    }

  unless hiera('rhizo::local_bsc_cfg') == "1" {

    file { '/etc/osmocom/osmo-nitb.cfg':
        content => template('rhizo_base/osmo-nitb.cfg.erb'),
        require => Package['osmocom-nitb'],
        notify  => Exec['notify-nitb'],
    }
  }

  exec { 'hlr_pragma_wal':
      command     =>
        '/usr/bin/sqlite3 /var/lib/osmocom/hlr.sqlite3 "PRAGMA journal_mode=wal;"',
      require     => Class['rhizo_base::packages'],
      refreshonly => true,
    }

  exec { 'notify-nitb':
      command     => '/bin/echo 1 > /tmp/OSMO-dirty',
      refreshonly => true,
    }

  exec { 'restart-nitb':
      command     => '/usr/bin/sv restart osmo-nitb',
      require     => Class['rhizo_base::packages'],
      refreshonly => true,
    }

}
