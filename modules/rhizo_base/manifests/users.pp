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

  $password_hash = $rhizo::password_hash

  user { 'rhizomatica':
      ensure   => present,
      gid      => 'rhizomatica',
      home     => '/home/rhizomatica',
      password => $rhizo::password_hash,
      purge_ssh_keys => true
      }
  }
