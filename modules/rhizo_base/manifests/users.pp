# Class: rhizo_base::users
#
# This module manages the users on the BSCs.
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::users {
  user { 'rhizomatica':
      ensure   => present,
      gid      => 'rhizomatica',
      home     => '/home/rhizomatica',
      password => '$6$rmdUFkJn$iR5BJ1RLrXmUVlXl7cwgcmB/HnGbXuyh.s9.JgTM1QFemtqBpICvi3iR9v2K2mZgGsqm1dOiwgpfFUnTKH/Zn0',
      uid      => '1000',
      }
  }