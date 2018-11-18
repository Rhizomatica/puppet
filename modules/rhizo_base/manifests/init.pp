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
  $use_ups         = hiera('rhizo::use_ups')
  $rhizomatica_dir = hiera('rhizo::rhizomatica_dir')
  $sq_hlr_path     = hiera('rhizo::sq_hlr_path')
  $use_sip         = hiera('rhizo::use_sip')
  $advice_email    = hiera('rhizo::advice_email')
  $charge_scheme   = hiera('rhizo::charge_scheme', 'normal')

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
  $gprs             = hiera('rhizo::gprs')
  
  #BTSs configuration
  $bts_type        = hiera('rhizo::bts_type')
  $bts1_ip_address = hiera('rhizo::bts1_ip_address')
  $arfcn_A         = hiera('rhizo::arfcn_A')
  $arfcn_B         = hiera('rhizo::arfcn_B', false)
  $bts1_name       = hiera('rhizo::bts1_name', "${site_name}_1")

  $bts2_ip_address = hiera('rhizo::bts2_ip_address', false)
  $arfcn_C         = hiera('rhizo::arfcn_C', false)
  $arfcn_D         = hiera('rhizo::arfcn_D', false)
  $bts2_name       = hiera('rhizo::bts2_name', "${site_name}_2")

  $bts3_ip_address = hiera('rhizo::bts3_ip_address', false)
  $arfcn_E         = hiera('rhizo::arfcn_E', false)
  $arfcn_F         = hiera('rhizo::arfcn_F', false)
  $bts3_name       = hiera('rhizo::bts3_name', "${site_name}_3")

  $max_power_red   = hiera('rhizo::max_power_red')

  # IP address
  $vpn_ip_address = hiera('rhizo::vpn_ip_address')
  $wan_ip_address = hiera('rhizo::wan_ip_address')
  $riak_ip_address = hiera('rhizo::riak_ip_address', $vpn_ip_address)
  $sip_central_ip_address = hiera('rhizo::sip_central_ip_address')
  $latency_check_address = hiera('rhizo::latency_check_address','1.1.1.1')

  $stats_disk = hiera('rhizo::stats_disk','')
  $stats_if = hiera('rhizo::stats_if','eth0')

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

  $default_log_level = hiera('rhizo::default_log_level', 'INFO')

  $kannel_server           = hiera('rhizo::kannel_server')
  $kannel_port             = hiera('rhizo::kannel_port')
  $kannel_username         = hiera('rhizo::kannel_username')
  $kannel_sendsms_password = hiera('rhizo::kannel_sendsms_password')
  $use_kannel              = hiera('rhizo::use_kannel', 'yes')
  $smpp_password           = hiera('rhizo::smpp_password', 'Password')

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

  #Number to send low VOIP Balance alert
  $admin_contact       = hiera('rhizo::admin_contact','')
  $support_contact     = hiera('rhizo::support_contact','')

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
  include rhizo_base::packages
  include rhizo_base::freeswitch
  include rhizo_base::runit
  include rhizo_base::openbsc
  include rhizo_base::lcr
  include rhizo_base::sudo
  include rhizo_base::users
  if $operatingsystem != 'Debian' {
    include rhizo_base::icinga
  }
  include rhizo_base::kiwi

  if $vpn_ip_address == $riak_ip_address {
    if $operatingsystem != 'Debian' {
      file { '/etc/init.d/riak':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          source  => 'puppet:///modules/rhizo_base/etc/init.d/riak',
          #require => Class['::riak'],
          #notify  => Exec['insserv'],
        }
        #include rhizo_base::riak
    }
  } else {
      file { '/etc/init.d/riak':
        ensure  => absent,
      }
  }

schedule { 'always':
  period => hourly,
  repeat => 2,
}

schedule { 'onceday':
  period => daily,
  repeat => 1,
}

schedule { 'onceweek':
  period => weekly,
  repeat => 1,
}

schedule { 'weekly':
  weekday => 'Sunday',
}

schedule { 'offpeak':
  range => '1 - 4.30',
}

schedule { 'repo':
  range => '1 - 2',
}

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

  file { "/etc/profile.d/rccn-functions.sh":
      ensure  => present,
      content  => template('rhizo_base/rccn-functions.sh.erb'),
    }

  file { '/var/rhizomatica':
      ensure  => directory,
    }

  file { '/var/rhizo_backups':
      ensure  => directory,
    }

  file { '/var/www/html':
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
      schedule => 'repo',
      ensure   => latest,
      provider => git,
      source   => 'https://github.com/Rhizomatica/rccn.git',
      revision => 'master',
      require  => [ File['/var/rhizomatica'], Package['git'] ],
      notify   => [ Exec['locale-gen'],
                    Exec['notify-freeswitch'],
                    Exec['restart-rapi'],
                    Exec['restart-smpp'],
                    Exec['restart-esme'] ],
    }

  vcsrepo { '/var/meas_web':
      schedule => 'repo',
      ensure   => latest,
      provider => git,
      source   => 'https://github.com/whyteks/meas_web.git',
      revision => 'master',
      require  => [ Package['git'] ],
      notify   => [ Exec['restart-meas'] ],
    }


  file { '/var/rhizomatica/bin/get_account_balance.sh':
      ensure  => present,
      content => template('rhizo_base/get_account_balance.sh.erb'),
      require => Vcsrepo['/var/rhizomatica'],
      mode    => '0755',
    }

  file { '/var/rhizomatica/bin/check_account_balance.sh':
      ensure  => present,
      content => template('rhizo_base/check_account_balance.sh.erb'),
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

  if $operatingsystem == 'Debian' {  
    exec { 'locale-gen':
        command     => '/usr/sbin/locale-gen',
        require     => [ File['/var/rhizomatica/rccn/config_values.py'],
        File['/etc/locale.gen'] ],
        refreshonly => true,
        }
  }
  
  if $operatingsystem == 'Ubuntu' {  
    exec { 'locale-gen':
        command     => '/usr/sbin/locale-gen',
        require     => [ File['/var/rhizomatica/rccn/config_values.py'],
        File['/var/lib/locales/supported.d/local'] ],
        refreshonly => true,
        }
  }  

  exec { 'notify-freeswitch':
      command     => '/bin/echo 1 > /tmp/FS-dirty',
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

  exec { 'restart-smpp':
      command     => '/usr/bin/sv restart smpp',
      refreshonly => true,
    }

  exec { 'restart-meas':
      command     => '/usr/bin/sv restart meas-web',
      refreshonly => true,
    }

  exec { 'restart-esme':
      command     => '/usr/bin/sv restart esme',
      refreshonly => true,
    }
  
  if $operatingsystem == 'Ubuntu' {
    file { '/var/lib/locales/supported.d/local':
        ensure      => present,
        source      => 'puppet:///modules/rhizo_base/var/lib/locales/supported.d/local',
      }
  }
  
  if $operatingsystem == 'Debian' {
     file { '/etc/locale.gen':
        ensure      => present,
        source      => 'puppet:///modules/rhizo_base/etc/locale.gen',
     }
  }

  file { '/var/log/rccn':
      ensure  => link,
      target  => '/var/rhizomatica/rccn/log',
      require => [ Vcsrepo['/var/rhizomatica'] ],
    }
  
  file { '/var/www/meas':
      ensure  => link,
      target  => '/var/meas_web/usr/share/fairwaves-meas-web/',
      require => [ Vcsrepo['/var/meas_web'] ],
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

  file { '/root/.ssh':
      ensure => directory
    }

#Python modules
  class { 'python':
      version => 'system',
      pip     => true,
      dev     => true,
    }

  if $operatingsystem == 'Debian' {
    python::pip { 'twisted':
        schedule => 'onceweek',
        ensure  => '13.1.0',
        pkgname => 'Twisted',
      }
  
    python::pip { 'corepost':
        schedule => 'onceweek',
        ensure  => 'present',
        pkgname => 'CorePost',
      }
  }

  python::pip { 'riak':
      ensure  => '2.0.3',
      pkgname => 'riak',
      schedule => 'onceweek',
    }

  python::pip { 'gsm0338':
      ensure  => '1.0.0',
      pkgname => 'gsm0338',
      schedule => 'onceweek',
    }

  python::pip { 'python-ESL':
      ensure  => 'present',
      pkgname => 'python-ESL',
      schedule => 'onceweek',
    }

  python::pip { 'csvkit':
      ensure  => 'present',
      pkgname => 'csvkit',
      schedule => 'onceweek',
    }

  file { '/usr/lib/python2.7/dist-packages':
      ensure  => directory,
      source  => 'puppet:///modules/rhizo_base/usr/lib/python2.7/dist-packages',
      recurse => remote,
      require => Class['python'],
    }

  file { '/etc/apcupsd/apcupsd.conf':
      ensure  => present,
      source  => 'puppet:///modules/rhizo_base/etc/apcupsd/apcupsd.conf',
      require => Package['apcupsd'],
    }

  file { '/etc/default/apcupsd':
      ensure => 'present',
      content => template('rhizo_base/apcupsd.erb'),
    }

  file { '/etc/cron.d/rhizomatica':
      ensure => 'present',
      content => template('rhizo_base/rhizomatica.cron.erb'),
    }

  host { 'mail':
      ip => '10.23.0.11',
  }

}
