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
  include "rhizo_base::postgresql::$operatingsystem"
}

class rhizo_base::postgresql::common {

  $pgsql_db   = $rhizo_base::pgsql_db
  $pgsql_user = $rhizo_base::pgsql_user
  $pgsql_pwd  = $rhizo_base::pgsql_pwd
  $pgsql_host = $rhizo_base::pgsql_host
  $pgsql_listen = $rhizo_base::vpn_ip_address

  postgresql::server::role { $pgsql_user:
    password_hash => postgresql_password($pgsql_user, $pgsql_pwd),
    superuser => true,
    }
  
  postgresql::server::db { $pgsql_db:
      user     => $pgsql_user,
      password => postgresql_password($pgsql_user, $pgsql_pwd),
    }

  postgresql::server::pg_hba_rule { 'allow from DC':
    description => 'PostgreSQL access from DC',
    type        => 'host',
    database    => 'rhizomatica',
    user        => 'rhizomatica',
    address     => '10.23.0.3/32',
    auth_method => 'md5',
    }

}

class rhizo_base::postgresql::ubuntu inherits rhizo_base::postgresql::common {

  class { 'postgresql::globals':
      manage_package_repo => true,
      version             => '9.3',
    }->
  class { 'postgresql::server':
      listen_addresses => "localhost, $pgsql_listen",
    }

}

class rhizo_base::postgresql::debian inherits rhizo_base::postgresql::common {

  class { 'postgresql::globals':
      manage_package_repo => true,
      version             => '9.4',
    }-> 
  class { 'postgresql::server':
      listen_addresses => "localhost, $pgsql_listen",
    }

}