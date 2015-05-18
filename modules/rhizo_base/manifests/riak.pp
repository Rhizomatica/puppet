# Class: rhizo_base::riak
#
# This module manages the Riak database
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class rhizo_base::riak {
  class { 'riak':
      version         => '1.4.10-1',
      template        => 'rhizo_base/app.config.erb',
      vmargs_template => 'rhizo_base/vm.args.erb',
    }
  }