# Class: rhizo_base::postgresql
#
# This module manages the PostgreSQL database
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::postgresql {
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
  }
