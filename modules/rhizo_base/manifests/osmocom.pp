# Class: rhizo_base::osmocom
#
# This module manages the Osmocom stack
#
# Parameters: none
#
# Actions:
#

class rhizo_base::osmocom {

  $network_name    = $rhizo_base::network_name
  $mcc             = $rhizo_base::mcc
  $mnc             = $rhizo_base::mnc
  $bts             = hiera('rhizo::bts')

  $smsc_password   = $rhizo_base::smsc_password
  $smpp_password   = $rhizo_base::smpp_password

  $mncc_codec      = $rhizo_base::mncc_codec

  $mncc_ip_address = $rhizo_base::mncc_ip_address
  $vpn_ip_address  = hiera('rhizo::vpn_ip_address')
  $sgsn_ip_address = hiera('rhizo::sgsn_ip_address')
  $ggsn_ip_address = hiera('rhizo::ggsn_ip_address')
  $repo            = hiera('rhizo::osmo_repo', 'latest')

  package {  [ 'osmo-stp', 'osmo-mgw', 'osmo-sgsn' ]:
      ensure   => 'installed',
      require  => Class['rhizo_base::apt']
    }

  $bsc_version = $repo ? {
    'latest'    => '1.6.1',
    'nightly'   => 'latest',
    default     => '1.6.1',
  }

  package {  [ 'osmo-bsc' ]:
      ensure   => $bsc_version,
      require  => Class['rhizo_base::apt'],
      notify   => Exec['hlr_pragma_wal']
    }

  package {  [ 'osmo-msc' ]:
      ensure   => 'installed',
      require  => Class['rhizo_base::apt'],
      notify   => Exec['sms_pragma_wal']
    }

  package {  [ 'osmo-hlr' ]:
      ensure   => 'installed',
      require  => Class['rhizo_base::apt'],
      notify   => Exec['hlr_pragma_wal']
    }

  $sipcon_version = $repo ? {
     'latest'    => '1.4.1',
     'nightly'   => 'latest',
     default     => '1.4.1',
    }

  package {  [ 'osmo-sip-connector' ]:
      ensure   => $sipcon_version,
      require  => Class['rhizo_base::apt'],
    }

  $utils_version = $repo ? {
     'latest'    => '1.6.1',
     'nightly'   => 'latest',
     default     => '1.6.1',
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

  unless hiera('rhizo::local_osmobsc_cfg') == "1" {
     file { '/etc/osmocom/osmo-bsc.cfg':
         ensure => file,
         content => template(
               'rhizo_base/osmo-bsc-head.erb',
               'rhizo_base/osmo-bsc-bts.erb',
               'rhizo_base/osmo-bsc-tail.erb'),
       }
  }

  # We used to notify the osmo-nitb on config changes for a restart
  # but with the service outage that restarting the split stack entails,
  # I don't want to even give puppet the possibility to do that.


  file { '/etc/osmocom/osmo-stp.cfg':
      content => template('rhizo_base/osmo-stp.cfg.erb'),
      require => Package['osmo-stp'],
    }

  file { '/etc/osmocom/osmo-hlr.cfg':
      content => template('rhizo_base/osmo-hlr.cfg.erb'),
      require => Package['osmo-hlr'],
    }

  file { '/etc/osmocom/osmo-msc.cfg':
      content => template('rhizo_base/osmo-msc.cfg.erb'),
      require => Package['osmo-msc'],
    }

  file { '/etc/osmocom/osmo-mgw.cfg':
      content => template('rhizo_base/osmo-mgw.cfg.erb'),
      require => Package['osmo-mgw'],
    }

  file { '/etc/osmocom/osmo-mgw2.cfg':
      content => template('rhizo_base/osmo-mgw2.cfg.erb'),
      require => Package['osmo-mgw'],
    }

  file { '/etc/osmocom/osmo-sip-connector.cfg':
      content => template('rhizo_base/osmo-sip-connector.cfg.erb'),
      require => Package['osmo-sip-connector'],
    }

  file { '/lib/systemd/system/osmo-msc.service':
      ensure   => present,
      source   => 'puppet:///modules/rhizo_base/systemd/osmo-msc.service',
    }

  file { '/lib/systemd/system/osmo-mgw-msc.service':
      ensure   => present,
      source   => 'puppet:///modules/rhizo_base/systemd/osmo-mgw-msc.service',
    }

  service { [ 'osmo-stp', 'osmo-hlr', 'osmo-bsc',
              'osmo-msc', 'osmo-mgw', 'osmo-sgsn',
              'osmo-sip-connector' ]:
    enable  => true,
    ensure  => 'running'
  }

  service { 'osmocom-nitb':
    provider => 'systemd',
    enable   => false,
    ensure   => 'stopped'
  }

  service { 'osmo-nitb':
    provider => 'runit',
    ensure   => 'stopped'
  }

  exec { 'hlr_pragma_wal':
      command     =>
        '/usr/bin/sqlite3 /var/lib/osmocom/hlr.db "PRAGMA journal_mode=wal;"',
      require     => Class['rhizo_base::packages'],
      refreshonly => true,
   }

  exec { 'sms_pragma_wal':
      command     =>
        '/usr/bin/sqlite3 /var/lib/osmocom/sms.db "PRAGMA journal_mode=wal;"',
      require     => Class['rhizo_base::packages'],
      refreshonly => true,
   }

  exec { 'notify-osmo-restart':
      command     => '/bin/echo 1 > /tmp/OSMO-dirty',
      refreshonly => true,
    }

}
