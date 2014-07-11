# Class: rhizomatica_base_system
#
# This module manages rhizomatica_base_system
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizomatica_base_system {

  $vpn_address = hiera('rhizo::vpn_address')
  $postgresql_password = hiera('rhizo::postgresql_password')
  $smsc_password= hiera('rhizo::smsc_password')
  $kannel_admin_password = ('rhizo::kannel_admin_password')
  $kannel_sendsms_password = hiera('rhizo::kannel_sendsms_password')

  include 'ntp'
  include 'kannel'

  file { '/etc/apt/apt.conf.d/90unsigned':
      ensure  => present,
      content => 'APT::Get::AllowUnauthenticated "true";',
    }
  
  class { 'apt': }

  apt::source { 'rhizomatica':
      location          => 'http://dev.rhizomatica.org/ubuntu/',
      release           => 'precise',
      repos             => 'main',
      include_src       => false,
      require           => File['/etc/apt/apt.conf.d/90unsigned'],
    }

  apt::source { 'mosh':
      location          => 'http://ppa.launchpad.net/keithw/mosh/ubuntu',
      release           => 'precise',
      repos             => 'main',
      key               => '7BF6DFCD',
      include_src       => false,
      require           => File['/etc/apt/apt.conf.d/90unsigned'],
    }


#  file { '/var/rhizomatica':
#      ensure  => directory,
#    }

  file { '/var/www/rmai':
      ensure  => link,
      target  => '/var/rhizomatica/rmai',
    }

  class { 'postgresql::globals':
      manage_package_repo => true,
      version             => '9.3',
    }->
  class { 'postgresql::server':
    }

  postgresql::server::db { 'rhizomatica':
      user     => 'rhizomatica',
      password => postgresql_password('rhizomatica', $postgresql_password),
    }

  package { ['openvpn', 'lm-sensors', 'runit']:
      ensure  => installed,
    }

  file { '/etc/sv':
      ensure  => directory,
      source  => "puppet:///modules/rhizomatica_base_system/etc/sv",
      recurse => true,
    }

  file { '/etc/service/osmo-nitb':
      ensure  => link,
      target  => "/etc/sv/osmo-nitb",
    }

file { '/etc/service/freeswitch':
      ensure  => link,
      target  => "/etc/sv/freeswitch",
    }

file { '/etc/service/rapi':
      ensure  => link,
      target  => "/etc/sv/rapi",
    }

  package { 'mosh':
      ensure  => installed,
      require => Apt::Source['mosh'],
    }

  class { 'riak':
      version => '1.4.7-1',
      template => 'rhizomatica_base_system/app.config.erb',
      vmargs_template => 'rhizomatica_base_system/vm.args.erb',
    }
  
  class { 'python':
      version => 'system',
      pip     => true,
      dev     => true,
    }

  python::pip { 'riak':
      ensure  => present,
    }

  package { ['apache2','libapache2-mod-php5', 'rrdtool', 'python-twisted-web', 'python-psycopg2', 'python-pysqlite2',
             'php5', 'php5-pgsql', 'php5-curl', 'python-corepost']:
      ensure  => installed,
    }

  package { ['freeswitch', 'freeswitch-lang-en', 'freeswitch-mod-amr', 'freeswitch-mod-amrwb', 'freeswitch-mod-b64',
             'freeswitch-mod-bv', 'freeswitch-mod-cdr-pg-csv', 'freeswitch-mod-cluechoo', 'freeswitch-mod-commands',
             'freeswitch-mod-conference', 'freeswitch-mod-console', 'freeswitch-mod-db', 'freeswitch-mod-dialplan-asterisk',
             'freeswitch-mod-dialplan-xml', 'freeswitch-mod-dptools', 'freeswitch-mod-enum', 'freeswitch-mod-esf', 
             'freeswitch-mod-event-socket','freeswitch-mod-expr', 'freeswitch-mod-fifo','freeswitch-mod-fsv',
             'freeswitch-mod-g723-1', 'freeswitch-mod-g729', 'freeswitch-mod-h26x', 'freeswitch-mod-hash',
             'freeswitch-mod-httapi', 'freeswitch-mod-local-stream', 'freeswitch-mod-logfile', 'freeswitch-mod-loopback',
             'freeswitch-mod-lua', 'freeswitch-mod-native-file', 'freeswitch-mod-python', 'freeswitch-mod-say-en',
             'freeswitch-mod-say-es', 'freeswitch-mod-sms', 'freeswitch-mod-sndfile', 'freeswitch-mod-sofia',
             'freeswitch-mod-spandsp', 'freeswitch-mod-speex', 'freeswitch-mod-syslog', 'freeswitch-mod-tone-stream',
             'freeswitch-mod-voicemail', 'freeswitch-mod-voicemail-ivr', 'freeswitch-mod-vp8', 'freeswitch-mod-xml-cdr',
             'freeswitch-sysvinit', 'libfreeswitch1']:
      ensure  => installed,
      require => Apt::Source['rhizomatica'],
    }

  package { ['osmocom-nitb', 'osmocom-nitb-dbg']:
      ensure  => installed,
      require => Apt::Source['rhizomatica'],
    }

}
