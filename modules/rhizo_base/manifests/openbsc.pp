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
  $lac             = $rhizo_base::lac
  $ms_max_power    = $rhizo_base::ms_max_power
  $max_power_red   = $rhizo_base::max_power_red
  $gsm_band        = $rhizo_base::gsm_band
  $mcc             = $rhizo_base::mcc
  $mnc             = $rhizo_base::mnc
  $arfcn_A         = $rhizo_base::arfcn_A
  $arfcn_B         = $rhizo_base::arfcn_B
  $arfcn_C         = $rhizo_base::arfcn_C
  $arfcn_D         = $rhizo_base::arfcn_D
  $arfcn_E         = $rhizo_base::arfcn_E
  $arfcn_F         = $rhizo_base::arfcn_F
  $bts2_ip_address = $rhizo_base::bts2_ip_address
  $bts3_ip_address = $rhizo_base::bts3_ip_address
  $smsc_password   = $rhizo_base::smsc_password
  $smpp_password   = $rhizo_base::smpp_password
  $mncc_codec      = $rhizo_base::mncc_codec
  $gprs            = $rhizo_base::gprs
  $mncc_ip_address = $rhizo_base::mncc_ip_address
  $vpn_ip_address  = hiera('rhizo::vpn_ip_address')
  $sgsn_ip_address = hiera('rhizo::sgsn_ip_address')
  $ggsn_ip_address = hiera('rhizo::ggsn_ip_address')
  $repo            = hiera('rhizo::osmo_repo', 'latest')
  $bts             = hiera('rhizo::bts')

  $nitb_version = $repo ? {
    'latest'    => '1.3.2',
    'nightly'   => 'latest',
    default     => '1.3.0',
  }

  package {  [ 'osmocom-nitb' ]:
      ensure   => $nitb_version,
      require  => Class['rhizo_base::apt'],
      notify   => [ Exec['hlr_pragma_wal'],
                    Exec['notify-nitb'] ],
    }

  package {  [ 'osmo-sip-connector' ]:
      ensure   => 'installed',
      require  => Class['rhizo_base::apt'],
      notify   => [ Exec['hlr_pragma_wal'],
                  ],
    }

  $utils_version = $repo ? {
    'latest'    => '1.6.0',
    'nightly'   => 'latest',
    default     => '1.6.0',
    }

  package { [ 'osmo-bsc-meas-utils' ]:
      ensure   => $utils_version,
    }

  package { [ 'libosmocore-utils' ]:
      ensure   => 'installed',
    }

  if $mncc_codec == "AMR" {
       $phys_chan = "TCH/H"
  } else {
       $phys_chan = "TCH/F"
  }

  service { 'osmocom-nitb':
      enable  => false,
      ensure  => 'stopped',
      require => Package['osmocom-nitb'],
    }

  service { 'osmo-nitb':
      enable  => false,
      ensure  => 'stopped',
      require => Package['osmocom-nitb'],
    }

  service { 'osmo-sip-connector':
      enable  => false,
      ensure  => stopped,
      require => Package['osmo-sip-connector'],
    }

  file { '/usr/local/bin/vty':
      source  => 'puppet:///modules/rhizo_base/vty',
      owner   => 'root',
      mode    => '0755',
    }

  file { '/etc/default/osmocom-nitb':
      source  => 'puppet:///modules/rhizo_base/etc/default/osmocom-nitb',
      require => Package['osmocom-nitb'],
    }

  unless hiera('rhizo::local_bsc_cfg') == "1" {
    file { '/etc/osmocom/osmo-nitb.cfg':
        content => template(
            'rhizo_base/osmo-nitb-head.erb',
            'rhizo_base/osmo-nitb-bts.erb',
            'rhizo_base/osmo-nitb-tail.erb'),
        require => Package['osmocom-nitb'],
        notify  => Exec['notify-nitb'],
      }
  }

  file { '/etc/osmocom/osmo-sip-connector.cfg':
      content => template('rhizo_base/osmo-sip-connector.cfg.erb'),
      require => Package['osmo-sip-connector'],
    }

  if ($gprs == "active") {
    file { '/etc/osmocom/make_sgsn_acl_config':
         content => template('rhizo_base/make_sgsn_acl_config.erb'),
         mode => "0750",
      }
    package {  [ 'osmo-sgsn' ]:
        ensure   => 'installed',
        require  => Class['rhizo_base::apt'],
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
