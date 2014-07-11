# Class: kannel
#
# This module manages kannel
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class kannel (
  $kannel_bind_address = hiera('rhizo::vpn_address')
) {

  package { 'kannel':
      ensure  => present,
  }
  
  file { '/etc/kannel/kannel.conf':
      ensure  => present,
      content => template("kannel/kannel.conf.erb"),
      require => Package['kannel'],
      notify  => Service['kannel'],
  }

  file { '/etc/default/kannel':
      ensure  => present,
      source  => ['puppet:///modules/kannel/kannel-default'],
      notify  => Service['kannel'],
  }

  service { 'kannel':
      ensure  => running,
      enable  => true,
      require => Package['kannel'],
  }
}
