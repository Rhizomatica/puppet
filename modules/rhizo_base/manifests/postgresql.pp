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

  $pgsql_db   = $rhizo_base::pgsql_db
  $pgsql_user = $rhizo_base::pgsql_user
  $pgsql_pwd  = $rhizo_base::pgsql_pwd
  $pgsql_host = $rhizo_base::pgsql_host

  class { 'postgresql::globals':
      manage_package_repo => true,
      version             => '9.3',
    }->
  class { 'postgresql::server':
    }

  postgresql::server::db { $pgsql_db:
      user     => $pgsql_user,
      password => postgresql_password($pgsql_user, $pgsql_pwd),
    }
  }
