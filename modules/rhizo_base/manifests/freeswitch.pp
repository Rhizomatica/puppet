# Class: rhizo_base::freeswitch
#
# This module manages the FreeSWITCH system
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::freeswitch {

  include systemd

  $pgsql_db       = $rhizo_base::pgsql_db
  $pgsql_user     = $rhizo_base::pgsql_user
  $pgsql_pwd      = $rhizo_base::pgsql_pwd
  $pgsql_host     = $rhizo_base::pgsql_host

  $vpn_ip_address = $rhizo_base::vpn_ip_address
  $wan_ip_address = $rhizo_base::wan_ip_address

  $voip_username  = $rhizo_base::voip_username
  $voip_fromuser  = $rhizo_base::voip_fromuser
  $voip_password  = $rhizo_base::voip_password
  $voip_proxy     = $rhizo_base::voip_proxy

  package {
    ['freeswitch', 'freeswitch-lang-en',
    'freeswitch-mod-amr', 'freeswitch-mod-amrwb',
    'freeswitch-mod-b64', 'freeswitch-mod-bv',
    'freeswitch-mod-cluechoo',
    'freeswitch-mod-commands', 'freeswitch-mod-conference',
    'freeswitch-mod-console', 'freeswitch-mod-db',
    'freeswitch-mod-dialplan-asterisk', 'freeswitch-mod-dialplan-xml',
    'freeswitch-mod-dptools', 'freeswitch-mod-enum',
    'freeswitch-mod-esf', 'freeswitch-mod-event-socket',
    'freeswitch-mod-expr', 'freeswitch-mod-fifo',
    'freeswitch-mod-fsv', 'freeswitch-mod-g723-1',
    'freeswitch-mod-h26x', 'freeswitch-mod-hash',
    'freeswitch-mod-httapi', 'freeswitch-mod-local-stream',
    'freeswitch-mod-logfile', 'freeswitch-mod-loopback',
    'freeswitch-mod-lua', 'freeswitch-mod-native-file',
    'freeswitch-mod-python', 'freeswitch-mod-say-en',
    'freeswitch-mod-say-es', 'freeswitch-mod-sms',
    'freeswitch-mod-sndfile', 'freeswitch-mod-sofia',
    'freeswitch-mod-spandsp', 
    #'freeswitch-mod-speex',
    'freeswitch-mod-syslog', 'freeswitch-mod-tone-stream',
    'freeswitch-mod-voicemail', 'freeswitch-mod-voicemail-ivr',
    #'freeswitch-mod-vp8',
    'freeswitch-mod-xml-cdr',
    'freeswitch-mod-g729',
    'freeswitch-sysvinit', 'libfreeswitch1']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  service { 'freeswitch':
      enable  => false,
      require => Package['freeswitch']
    }


  file { '/etc/freeswitch':
      ensure  => directory,
      source  => 'puppet:///modules/rhizo_base/etc/freeswitch',
      recurse => remote,
      require => Package['freeswitch'],
    }

  file { '/etc/freeswitch/vars.xml':
      content => template('rhizo_base/vars.xml.erb'),
      require => Package['freeswitch'],
    }

  file {'/etc/freeswitch/sip_profiles/external':
      ensure  => directory,
    }

  file { '/etc/freeswitch/sip_profiles/external/provider.xml':
      content => template('rhizo_base/provider.xml.erb'),
      require =>
                [ Package['freeswitch'],
                File['/etc/freeswitch/sip_profiles/external'] ],
    }

  file { '/etc/freeswitch/autoload_configs/cdr_pg_csv.conf.xml':
      content => template('rhizo_base/cdr_pg_csv.conf.xml.erb'),
      require => Package['freeswitch'],
    }

  file { '/usr/lib/freeswitch/mod/mod_cdr_pg_csv.so':
      source  => 'puppet:///modules/rhizo_base/usr/lib/freeswitch/mod/mod_cdr_pg_csv.so',
      require => Package['freeswitch'],
    }

  file { '/etc/default/freeswitch':
      source  => 'puppet:///modules/rhizo_base/etc/default/freeswitch',
      require => Package['freeswitch'],
    }

  systemd::unit_file { 'freeswitch.service':
    source => "puppet:///modules/rhizo_base/freeswitch.service",
  }

  systemd::tmpfile { 'freeswitch.tmpfile':
    source => "puppet:///modules/rhizo_base/freeswitch.tmpfile",
  }

}


