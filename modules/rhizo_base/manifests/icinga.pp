# Class: rhizo_base::icinga
#
# This module manages Icinga2
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::icinga {

  package { 'icinga2':
      ensure  => '2.3.4~precise',
      require => Class['rhizo_base::apt'],
    }

  }