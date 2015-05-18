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
  package { ['osmocom-nitb', 'osmocom-nitb-dbg',
  'libdbd-sqlite3', 'libsmpp0']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
      notify  => Exec['hlr_pragma_wal'],
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
