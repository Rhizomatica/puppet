# Class: rhizo_base
#
# This module manages the Rhizomatica base system
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base {

  $mail_admins             = hiera('rhizo::mail_admins')
  $smsc_password           = hiera('rhizo::smsc_password')
  $kannel_admin_password   = hiera('rhizo::kannel_admin_password')
  $password_hash           = hiera('rhizo::password_hash')

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
  $network_name    = hiera('rhizo::network_name')
  $auth_policy     = hiera('rhizo::auth_policy')
  $lac             = hiera('rhizo::lac')

  #BTSs configuration
  $bts1_ip_address = hiera('rhizo::bts1_ip_address')
  $arfcn_A         = hiera('rhizo::arfcn_A')
  $arfcn_B         = hiera('rhizo::arfcn_B')

  $bts2_ip_address = hiera('rhizo::bts2_ip_address', false)
  $arfcn_C         = hiera('rhizo::arfcn_C', false)
  $arfcn_D         = hiera('rhizo::arfcn_D', false)

  $bts3_ip_address = hiera('rhizo::bts3_ip_address', false)
  $arfcn_E         = hiera('rhizo::arfcn_E', false)
  $arfcn_F         = hiera('rhizo::arfcn_F', false)

  $max_power_red   = hiera('rhizo::max_power_red')

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
  $voip_pin           = hiera('rhizo::voip_pin')
  $voip_proxy         = hiera('rhizo::voip_proxy')
  $voip_did           = hiera('rhizo::voip_did')
  $voip_cli           = hiera('rhizo::voip_cli')

  # Subscription SMS notification
  $notice_msg       = hiera('rhizo::notice_msg')
  $reminder_msg     = hiera('rhizo::reminder_msg')
  $deactivate_msg   = hiera('rhizo::deactivate_msg')
  $sms_credit_added = hiera('rhizo::sms_credit_added')

  #Roaming welcome SMS
  $sms_welcome_roaming = hiera('rhizo::sms_welcome_roaming')
  #Emergency number
  $emergency_contact   = hiera('rhizo::emergency_contact')

  #Device Geo Info
  $bsc_geo_lat         = hiera('rhizo::bsc_geo_lat')
  $bsc_geo_lon         = hiera('rhizo::bsc_geo_lon')

  $bts1_geo_lat         = hiera('rhizo::bts1_geo_lat')
  $bts1_geo_lon         = hiera('rhizo::bts1_geo_lon')

  $bts2_geo_lat         = hiera('rhizo::bts2_geo_lat', false)
  $bts2_geo_lon         = hiera('rhizo::bts2_geo_lon', false)

  $bts3_geo_lat         = hiera('rhizo::bts3_geo_lat', false)
  $bts3_geo_lon         = hiera('rhizo::bts3_geo_lon', false)

  $link1_ip_address     = hiera('rhizo::link1_ip_address', false)
  $link2_ip_address     = hiera('rhizo::link2_ip_address', false)
  $link3_ip_address     = hiera('rhizo::link3_ip_address', false)
  $link4_ip_address     = hiera('rhizo::link4_ip_address', false)
  $link5_ip_address     = hiera('rhizo::link5_ip_address', false)

  $link1_geo_lat        = hiera('rhizo::link1_geo_lat', false)
  $link1_geo_lon        = hiera('rhizo::link1_geo_lon', false)

  $link2_geo_lat        = hiera('rhizo::link2_geo_lat', false)
  $link2_geo_lon        = hiera('rhizo::link2_geo_lon', false)

  $link3_geo_lat        = hiera('rhizo::link3_geo_lat', false)
  $link3_geo_lon        = hiera('rhizo::link3_geo_lon', false)

  $link4_geo_lat        = hiera('rhizo::link4_geo_lat', false)
  $link4_geo_lon        = hiera('rhizo::link4_geo_lon', false)

  $link5_geo_lat        = hiera('rhizo::link5_geo_lat', false)
  $link5_geo_lon        = hiera('rhizo::link5_geo_lon', false)

  include ntp
  include kannel
  include sshkeys
  include rhizo_base::fixes
  include rhizo_base::apt
  include rhizo_base::postgresql
  include rhizo_base::riak
  include rhizo_base::packages
  include rhizo_base::freeswitch
  include rhizo_base::runit
  include rhizo_base::openbsc
  include rhizo_base::lcr
  include rhizo_base::sudo
  include rhizo_base::users
  include rhizo_base::icinga


#Rizhomatica scripts
  file { '/home/rhizomatica/bin':
      ensure  => directory,
      source  => 'puppet:///modules/rhizo_base/bin',
      recurse => true,
      purge   => false,
    }

  file { '/home/rhizomatica/bin/vars.sh':
      ensure  => present,
      content => template('rhizo_base/vars.sh.erb'),
    }

  file { '/var/rhizomatica':
      ensure  => directory,
    }

  file { '/var/rhizo_backups':
      ensure  => directory,
    }

  file { '/var/rhizo_backups/postgresql':
      ensure  => directory,
      owner   => 'postgres',
      group   => 'postgres',
      require => File['/var/rhizo_backups'],
    }

  file { '/var/rhizo_backups/sqlite':
      ensure  => directory,
      require => File['/var/rhizo_backups'],
    }

  vcsrepo { '/var/rhizomatica':
      ensure   => present,
      provider => git,
      source   => 'https://github.com/Rhizomatica/rccn.git',
     revision => '1.0.7',
      require  => [ File['/var/rhizomatica'], Package['git'] ],
      notify   => [ Exec['locale-gen'],
                    Exec['restart-freeswitch'],
                    Exec['restart-rapi'] ],
    }

  file { '/var/rhizomatica/bin/get_account_balance.sh':
      ensure  => present,
      content => template('rhizo_base/get_account_balance.sh.erb'),
      require => Vcsrepo['/var/rhizomatica'],
      mode    => '0755',
    }


  file { '/var/rhizomatica/rccn/config_values.py':
      ensure  => present,
      content => template('rhizo_base/config_values.py.erb'),
      require => Vcsrepo['/var/rhizomatica'],
    }

  file { '/var/rhizomatica/rai/include/database.php':
      ensure  => present,
      content => template('rhizo_base/database.php.erb'),
      require => Vcsrepo['/var/rhizomatica'],
    }

  file { '/var/www/html/rai/js/localnet.json':
      ensure  => present,
      content => template('rhizo_base/localnet.json.erb'),
    }

  exec { 'locale-gen':
      command     => '/usr/sbin/locale-gen',
      require     => [ File['/var/rhizomatica/rccn/config_values.py'],
      File['/var/lib/locales/supported.d/local'] ],
      refreshonly => true,
      }

  exec { 'restart-freeswitch':
      command     => '/usr/bin/sv restart freeswitch',
      refreshonly => true,
    }

  exec { 'restart-rapi':
      command     => '/usr/bin/sv restart rapi',
      refreshonly => true,
    }

  file { '/var/lib/locales/supported.d/local':
      ensure      => present,
      source      => 'puppet:///modules/rhizo_base/var/lib/locales/supported.d/local',
    }

  file { '/var/www/html/rai':
      ensure  => link,
      target  => '/var/rhizomatica/rai',
      require => [ Package['apache2'], Vcsrepo['/var/rhizomatica'] ],
    }

  file { '/var/www/html/rai/graphs':
      ensure  => link,
      target  => '/var/rhizomatica/rrd/graphs',
      require => Vcsrepo['/var/rhizomatica'],
    }


#Python modules
  class { 'python':
      version => 'system',
      pip     => true,
      dev     => true,
    }


  python::pip { 'riak':
      ensure  => '2.0.3',
      pkgname => 'riak',
    }

  file { '/usr/lib/python2.7/dist-packages':
      ensure  => directory,
      source  => 'puppet:///modules/rhizo_base/usr/lib/python2.7/dist-packages',
      recurse => remote,
      require => Class['python'],
    }

#Apache2 + PHP + Python
  package { ['apache2','libapache2-mod-php5',
  'rrdtool', 'python-twisted-web', 'python-psycopg2',
  'python-pysqlite2', 'php5', 'php5-pgsql',
  'php5-curl', 'php5-cli', 'php5-gd', 'python-corepost',
  'python-yaml', 'python-formencode', 'python-unidecode',
  'python-dateutil']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  file { '/etc/php5/apache2/php.ini':
      ensure  => present,
      source  => 'puppet:///modules/rhizo_base/etc/php5/apache2/php.ini',
      require => Package['libapache2-mod-php5'],
    }


  file { '/etc/cron.d/rhizomatica':
      source => 'puppet:///modules/rhizo_base/etc/cron.d/rhizomatica',
    }

  }
