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
  # TODO Switch to "contains" once legacy puppet3 support is no longer required.
  include "rhizo_base::postgresql::$operatingsystem"

  # Verbose anchor pattern used for legacy puppet support only.
  anchor { 'rhizo_base::postgresql::first': } ->
  Class["rhizo_base::postgresql::$operatingsystem"] ->
  anchor { 'rhizo_base::postgresql::last': }
}

class rhizo_base::postgresql::common {

  $pgsql_db   = $rhizo_base::pgsql_db
  $pgsql_user = $rhizo_base::pgsql_user
  $pgsql_pwd  = $rhizo_base::pgsql_pwd
  $pgsql_host = $rhizo_base::pgsql_host

  postgresql::server::db { $pgsql_db:
      user     => $pgsql_user,
      password => postgresql_password($pgsql_user, $pgsql_pwd),
    }

}

class rhizo_base::postgresql::ubuntu inherits rhizo_base::postgresql::common {

  # Verbose anchor pattern used for legacy puppet support only.
  # TODO Switch to "contains" once puppet3 support is no longer required.
  anchor { 'rhizo_base::postgresql::ubuntu::first': } ->
  class { 'postgresql::globals':
      manage_package_repo => true,
      version             => '9.3',
    } ->
  class { 'postgresql::server':
    } ->
  anchor { 'rhizo_base::postgresql::ubuntu::last': }

}

class rhizo_base::postgresql::debian inherits rhizo_base::postgresql::common {

  # Verbose anchor pattern used for legacy puppet support only.
  # TODO Switch to "contains" once puppet3 support is no longer required.
  anchor { 'rhizo_base::postgresql::debian::first': } ->
  class { 'postgresql::globals':
      manage_package_repo => true,
      version             => '9.6',
    } ->
  class { 'postgresql::server':
    } ->
  anchor { 'rhizo_base::postgresql::debian::last': }

}
