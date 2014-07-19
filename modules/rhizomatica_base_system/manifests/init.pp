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

  $bts1_ip_address         = hiera('rhizo::bts1_ip_address')
  $mail_admins             = hiera('rhizo::mail_admins')
  $smsc_password           = hiera('rhizo::smsc_password')
  $kannel_admin_password   = hiera('rhizo::kannel_admin_password')

  # Configuration settings
  $rhizomatica_dir = hiera('rhizo::rhizomatica_dir')
  $sq_hlr_path     = hiera('rhizo::sq_hlr_path')

  # database
  $pgsql_db   = hiera('rhizo::pgsql_db')
  $pgsql_user = hiera('rhizo::pgsql_user')
  $pgsql_pwd  = hiera('rhizo::pgsql_pwd')
  $pgsql_host = hiera('rhizo::pgsql_host')

  # SITE
  $site_name    = hiera('rhizo::site_name')
  $postcode     = hiera('rhizo::postcode')
  $pbxcode      = hiera('rhizo::pbxcode')
  # network name
  $network_name = hiera('rhizo::network_name')

  # VPN ip address
  $vpn_ip_address = hiera('rhizo::vpn_ip_address')
  $wan_ip_address = hiera('rhizo::wan_ip_address')

  # SITE settings
  # rate type can be "call" or "min"
  $limit_local_calls            = hiera('rhizo::limit_local_calls')
  $limit_local_minutes          = hiera('rhizo::limit_local_minutes')
  $charge_local_calls           = hiera('rhizo::charge_local_calls')
  $charge_local_rate            = hiera('rhizo::charge_local_rate')
  $charge_local_rate_type       = hiera('rhizo::charge_local_rate_type')
  $charge_internal_calls        = hiera('rhizo::charge_internal_calls')
  $charge_internal_rate         = hiera('rhizo::charge_internal_rate')
  $charge_internal_rate_type    = hiera('rhizo::charge_internal_rate_type')
  $charge_inbound_calls         = hiera('rhizo::charge_inbound_calls')
  $charge_inbound_rate          = hiera('rhizo::charge_inbound_rate')
  $charge_inbound_rate_type     = hiera('rhizo::charge_inbound_rate_type')
  $smsc_shortcode               = hiera('rhizo::smsc_shortcode')
  $sms_sender_unauthorized      = hiera('rhizo::sms_sender_unauthorized')
  $sms_destination_unauthorized = hiera('rhizo::sms_destination_unauthorized')

  $rai_admin_user  = hiera('rhizo::rai_admin_user')
  $rai_admin_pwd   = hiera('rhizo::rai_admin_pwd')

  $kannel_server           = hiera('rhizo::kannel_server')
  $kannel_port             = hiera('rhizo::kannel_port')
  $kannel_username         = hiera('rhizo::kannel_username')
  $kannel_sendsms_password = hiera('rhizo::kannel_sendsms_password')

  # VOIP provider
  $voip_provider_name = hiera('rhizo::voip_provider_name')
  $voip_username      = hiera('rhizo::voip_username')
  $voip_fromuser      = hiera('rhizo::voip_fromuser')
  $voip_password      = hiera('rhizo::voip_password')
  $voip_proxy         = hiera('rhizo::voip_proxy')
  $voip_did           = hiera('rhizo::voip_did')
  $voip_cli           = hiera('rhizo::voip_cli')

  # Subscription SMS notification
  $notice_msg     = hiera('rhizo::notice_msg')
  $reminder_msg   = hiera('rhizo::reminder_msg')
  $deactivate_msg = hiera('rhizo::deactivate_msg')

  include ntp
  include kannel

#Grub fix
  file { '/etc/default/grub':
      ensure  => present,
      source  => 'puppet:///modules/rhizomatica_base_system/etc/default/grub',
      notify  => Exec['update-grub'],
    }

  exec { 'update-grub':
      refreshonly => true,
    }

#Rizhomatica scripts
  file { '/home/rhizomatica/bin':
      ensure  => directory,
      source  => 'puppet:///modules/rhizomatica_base_system/bin',
      recurse => true,
      purge   => false,
    }

  file { '/home/rhizomatica/bin/vars.sh':
      ensure  => present,
      content => template('rhizomatica_base_system/vars.sh.erb'),
    }

#APT + Repos
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

  apt::ppa { 'ppa:keithw/mosh': }
  apt::ppa { 'ppa:ondrej/php5': }


  file { '/var/rhizomatica':
      ensure  => directory,
    }

  package { 'git':
      ensure => present,
    }

  vcsrepo { '/var/rhizomatica':
      ensure   => latest,
      provider => git,
      source   => 'https://github.com/Rhizomatica/rccn.git',
      revision => 'master',
      require  => [ File['/var/rhizomatica'], Package['git'] ],
      notify   => Exec['install_rccn'],
    }

  file { '/var/rhizomatica/rccn/config_values.py':
      ensure  => present,
      content => template('rhizomatica_base_system/config_values.py.erb'),
      require => Vcsrepo['/var/rhizomatica'],
    }

  file { '/var/rhizomatica/rai/include/database.php':
      ensure  => present,
      content => template('rhizomatica_base_system/database.php.erb'),
      require => Vcsrepo['/var/rhizomatica'],
    }

  exec { 'install_rccn':
      command     => '/usr/bin/python /var/rhizomatica/rccn/install.py',
      require     => [ File['/var/rhizomatica/rccn/config_values.py'],
      Class['postgresql::server'], Class['riak'],
      Package['php5'] ],
      refreshonly => true,
    }

  file { '/var/www/html/rai':
      ensure  => link,
      target  => '/var/rhizomatica/rai',
      require => Vcsrepo['/var/rhizomatica'],
    }

  file { '/var/www/html/rai/graphs':
      ensure  => link,
      target  => '/var/rhizomatica/rrd/graphs',
      require => Vcsrepo['/var/rhizomatica'],
    }

#PostgreSQL server
  class { 'postgresql::globals':
      manage_package_repo => true,
      version             => '9.3',
    }->
  class { 'postgresql::server':
    }

  postgresql::server::db { 'rhizomatica':
      user     => 'rhizomatica',
      password => postgresql_password('rhizomatica', $pgsql_pwd),
    }

#Various packages
  package { ['openvpn', 'lm-sensors', 'runit']:
      ensure  => installed,
    }

#Runit scripts
  file { '/etc/sv':
      ensure  => directory,
      source  => 'puppet:///modules/rhizomatica_base_system/etc/sv',
      recurse => remote,
      require => Package['runit'],
    }

  file { '/etc/service/osmo-nitb':
      ensure  => link,
      target  => '/etc/sv/osmo-nitb',
      require => [ File['/etc/sv'], Package['osmocom-nitb'] ],
    }

  file { '/etc/service/freeswitch':
      ensure  => link,
      target  => '/etc/sv/freeswitch',
      require => [ File['/etc/sv'], Package['freeswitch'] ],
    }

  file { '/etc/service/rapi':
      ensure  => link,
      target  => '/etc/sv/rapi',
      require => File['/etc/sv'],
    }

#Mosh
  package { 'mosh':
      ensure  => installed,
      require => Apt::Ppa['ppa:keithw/mosh'],
    }

#Riak server
  class { 'riak':
      version         => '1.4.7-1',
      template        => 'rhizomatica_base_system/app.config.erb',
      vmargs_template => 'rhizomatica_base_system/vm.args.erb',
    }

#Python modules
  class { 'python':
      version => 'system',
      pip     => true,
      dev     => true,
    }

  python::pip { 'riak':
      ensure  => present,
    }

  file { '/usr/lib/python2.7/dist-packages':
      ensure  => directory,
      source  => 'puppet:///modules/rhizomatica_base_system/usr/lib/python2.7/dist-packages',
      recurse => remote,
      require => Class['python'],
    }

#Apache2 + PHP
  package { ['apache2','libapache2-mod-php5',
  'rrdtool', 'python-twisted-web', 'python-psycopg2',
  'python-pysqlite2', 'php5', 'php5-pgsql',
  'php5-curl', 'php5-cli', 'php5-gd', 'python-corepost',
  'python-yaml', 'python-formencode']:
      ensure  => installed,
      require => Apt::Ppa['ppa:ondrej/php5'],
    }

  file { '/etc/php5/apache2/php.ini':
      ensure  => present,
      source  => 'puppet:///modules/rhizomatica_base_system/etc/php5/apache2/php.ini',
      require => Package['libapache2-mod-php5'],
    }

#FreeSWITCH
  package { ['freeswitch', 'freeswitch-lang-en',
  'freeswitch-mod-amr', 'freeswitch-mod-amrwb',
  'freeswitch-mod-b64', 'freeswitch-mod-bv',
  'freeswitch-mod-cdr-pg-csv', 'freeswitch-mod-cluechoo',
  'freeswitch-mod-commands', 'freeswitch-mod-conference',
  'freeswitch-mod-console', 'freeswitch-mod-db',
  'freeswitch-mod-dialplan-asterisk', 'freeswitch-mod-dialplan-xml',
  'freeswitch-mod-dptools', 'freeswitch-mod-enum', 'freeswitch-mod-esf',
  'freeswitch-mod-event-socket','freeswitch-mod-expr', 'freeswitch-mod-fifo',
  'freeswitch-mod-fsv', 'freeswitch-mod-g723-1', 'freeswitch-mod-h26x',
  'freeswitch-mod-hash', 'freeswitch-mod-httapi',
  'freeswitch-mod-local-stream', 'freeswitch-mod-logfile',
  'freeswitch-mod-loopback', 'freeswitch-mod-lua',
  'freeswitch-mod-native-file', 'freeswitch-mod-python',
  'freeswitch-mod-say-en', 'freeswitch-mod-say-es', 'freeswitch-mod-sms',
  'freeswitch-mod-sndfile', 'freeswitch-mod-sofia', 'freeswitch-mod-spandsp',
  'freeswitch-mod-speex', 'freeswitch-mod-syslog',
  'freeswitch-mod-tone-stream', 'freeswitch-mod-voicemail',
  'freeswitch-mod-voicemail-ivr', 'freeswitch-mod-vp8',
  'freeswitch-mod-xml-cdr', 'freeswitch-sysvinit', 'libfreeswitch1']:
      ensure  => installed,
      require => Apt::Source['rhizomatica'],
    }

  file { '/usr/lib/freeswitch/mod/mod_g729.so':
      source  => 'puppet:///modules/rhizomatica_base_system/mod_g729.so',
      require => Package['freeswitch'],
    }

  file { '/etc/freeswitch':
      ensure  => directory,
      source  => 'puppet:///modules/rhizomatica_base_system/etc/freeswitch',
      recurse => remote,
      require => Package['freeswitch'],
    }

  file { '/etc/freeswitch/vars.xml':
      content => template('rhizomatica_base_system/vars.xml.erb'),
      require => Package['freeswitch'],
    }

  file {'/etc/freeswitch/sip_profiles/external':
      ensure  => directory,
    }

  file { '/etc/freeswitch/sip_profiles/external/provider.xml':
      content => template('rhizomatica_base_system/provider.xml.erb'),
      require => [ Package['freeswitch'],
      File['/etc/freeswitch/sip_profiles/external'] ],
    }

#OpenBSC
  package { ['osmocom-nitb', 'osmocom-nitb-dbg']:
      ensure  => installed,
      require => Apt::Source['rhizomatica'],
    }

  file { '/etc/osmocom/osmo-nitb.cfg':
      content => template('rhizomatica_base_system/osmo-nitb.cfg.erb'),
      require => Package['osmocom-nitb'],
    }

#LCR
  package { 'lcr':
      ensure  => installed,
      require => Apt::Source['rhizomatica'],
    }

  file { '/usr/etc/lcr':
      ensure  => directory,
      source  => 'puppet:///modules/rhizomatica_base_system/usr/etc/lcr',
      recurse => remote,
      purge   => true,
      require => Package['lcr'],
    }

  file { '/etc/default/lcr':
      ensure  => present,
      source  => 'puppet:///modules/rhizomatica_base_system/etc/default/lcr',
      require => Package['lcr'],
    }

  file { '/etc/cron.d/rhizomatica':
      source => 'puppet:///modules/rhizomatica_base_system/etc/cron.d/rhizomatica',
    }

  }
