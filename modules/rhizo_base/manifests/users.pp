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
      uid      => '1000',
      purge_ssh_keys => true
  }

  file { '/home/rhizomatica/.ssh/config':
      content  => template('rhizo_base/ssh_user_config.erb'),
      owner    => 'rhizomatica',
      group    => 'rhizomatica',
      mode     => '0600'
  }

}