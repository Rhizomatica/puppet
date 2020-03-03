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
  contain "rhizo_base::freeswitch::$operatingsystem"
}

class rhizo_base::freeswitch::ubuntu inherits rhizo_base::freeswitch::common {

  file { '/usr/lib/freeswitch/mod/mod_g729.so':
      source  => 'puppet:///modules/rhizo_base/mod_g729.so.atom',
      require => Package['freeswitch'],
    }

  package {
    ['freeswitch-mod-speex','freeswitch-mod-cdr-pg-csv',
     'freeswitch-mod-vp8', 'freeswitch-sysvinit']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
  }

  service { 'freeswitch':
      enable  => false,
      require => Package['freeswitch']
    }

}

class rhizo_base::freeswitch::debian inherits rhizo_base::freeswitch::common {

  include systemd

  if $facts['processor0'] =~ /i3-5020U/ {
    file { '/usr/lib/freeswitch/mod/mod_g729.so':
        source  => 'puppet:///modules/rhizo_base/mod_g729.so.i3',
        require => Package['freeswitch'],
      }
  } elsif $facts['processor0'] =~ /i3-40/ {
    file { '/usr/lib/freeswitch/mod/mod_g729.so':
        source  => 'puppet:///modules/rhizo_base/mod_g729.so.i3',
        require => Package['freeswitch'],
      }
  } elsif $facts['processor0'] =~ /J3455/ {
    file { '/usr/lib/freeswitch/mod/mod_g729.so':
        source  => 'puppet:///modules/rhizo_base/mod_g729.so.atom',
        require => Package['freeswitch'],
      }
  } else {
    file { '/usr/lib/freeswitch/mod/mod_g729.so':
        source  => 'puppet:///modules/rhizo_base/mod_g729.so.atom',
        require => Package['freeswitch'],
      }
  }

  file { '/usr/lib/freeswitch/mod/mod_amr.so':
      source  => 'puppet:///modules/rhizo_base/mod_amr.so',
      require => Package['freeswitch'],
    }

  package {
    [ 'freeswitch-mod-g729' ]:
      ensure  => purged,
      require => Class['rhizo_base::apt'],
    }

  package {
    [ 'freeswitch-mod-opus' ]:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
  }

  file { '/etc/default/freeswitch':
      source  => 'puppet:///modules/rhizo_base/etc/default/freeswitch',
      require => Package['freeswitch'],
    }

  file { '/var/run/freeswitch':
      ensure => directory,
      owner   => 'freeswitch',
      group   => 'freeswitch',
      require => Package['freeswitch'],
    }

  systemd::unit_file { 'freeswitch.service':
    source => "puppet:///modules/rhizo_base/freeswitch.service",
    }

  systemd::tmpfile { 'freeswitch.tmpfile':
    source => "puppet:///modules/rhizo_base/freeswitch.tmpfile",
    }

}

class rhizo_base::freeswitch::common {

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
  $sip_central_ip_address = $rhizo_base::sip_central_ip_address
  $reg_provider   = $rhizo_base::reg_provider
  $mncc_ip_address = $rhizo_base::mncc_ip_address

  package {
    ['freeswitch', 'freeswitch-lang-en',
    'freeswitch-mod-amr', 'freeswitch-mod-amrwb',
    'freeswitch-mod-b64', 'freeswitch-mod-bv',
    'freeswitch-mod-commands', 'freeswitch-mod-conference',
    'freeswitch-mod-console', 'freeswitch-mod-db',
    'freeswitch-mod-dialplan-xml',
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
    'freeswitch-mod-spandsp', 'freeswitch-mod-shout',
    'freeswitch-mod-syslog', 'freeswitch-mod-tone-stream',
    'freeswitch-mod-voicemail', 'freeswitch-mod-voicemail-ivr',
    'freeswitch-mod-xml-cdr', 'freeswitch-mod-cdr-pg-csv',
    'libfreeswitch1',
    'freeswitch-sounds-es-mx-maria' ]:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  file { '/tmp/libfreeswitch.so.1.0.0':
      source  => 'puppet:///modules/rhizo_base/usr/lib/libfreeswitch.so.1.0.0-10.2',
      require => Package['freeswitch'],
    }

  file { '/tmp/libfreeswitch.so.1.0.0-3':
      source  => 'puppet:///modules/rhizo_base/usr/lib/libfreeswitch.so.1.0.0-10.3',
      require => Package['freeswitch'],
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

  file { '/etc/freeswitch/sip_profiles/internal.xml':
      content => template('rhizo_base/internal.xml.erb'),
    }

  file {'/etc/freeswitch/sip_profiles/outgoing':
      ensure  => directory,
    }

  file { '/etc/freeswitch/sip_profiles/outgoing/rhizomatica.xml':
      content => template('rhizo_base/rhizomatica.xml.erb'),
      require =>
                [ Package['freeswitch'],
                File['/etc/freeswitch/sip_profiles/outgoing'] ],
    }

  file { '/etc/freeswitch/autoload_configs/acl.conf.xml':
      content => template('rhizo_base/acl.conf.xml.erb'),
      require => Package['freeswitch'],
    }

  file { '/etc/freeswitch/autoload_configs/cdr_pg_csv.conf.xml':
      content => template('rhizo_base/cdr_pg_csv.conf.xml.erb'),
      require => Package['freeswitch'],
    }

  # SSH Deploy key and config for gitlab
  file { '/root/.ssh/bsc_dev':
      ensure  => present,
      mode    => '0600',
      content => hiera('rhizo::bsc_dev_deploy_key'),
  }

  file { '/root/.ssh/config':
      ensure => present,
      source => 'puppet:///modules/rhizo_base/ssh/config',
  }

  sshkey { 'dev_host_key':
      name   => 'dev.rhizomatica.org',
      ensure => present,
      key    => hiera('rhizo::dev_host_key'),
      type   => 'ssh-rsa',
  }

  vcsrepo { '/usr/share/freeswitch/sounds/rccn':
    schedule  => 'always',
    ensure    => latest,
    provider  => git,
    source    => 'git@dev.rhizomatica.org:rhizomatica/ticac_sounds.git',
    require   => File['/root/.ssh/bsc_dev'],
  }

}
