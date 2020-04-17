# Class: rhizo_base::ircd
#
# This module manages Irc Chat Support
#
# Parameters: none
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class rhizo_base::kiwi {

  $site_name     = $rhizo_base::site_name

  package {
    ['make', 'npm']:
      ensure  => installed,
      require => Class['rhizo_base::apt'],
    }

  package {
    ['nodejs']:
      ensure  => $lsbdistcodename ? {
        "stretch" => '0.10.48-1nodesource1~jessie1',
        "buster" => '10.15.2~dfsg-2',
      	},
      require => Class['rhizo_base::apt'],
    }

  file { '/usr/share/kiwiirc':
      ensure  => directory,
    }

  file { '/usr/share/kiwiirc/config.js':
      content  => template('rhizo_base/config.js.erb'),
      require  => VcsRepo['/usr/share/kiwiirc']
    }

  exec { 'npm-install':
      cwd      => '/usr/share/kiwiirc',
      command  => '/usr/bin/npm install',
      creates  => '/usr/share/kiwiirc/node_modules',
      require  => VcsRepo['/usr/share/kiwiirc']
    }

  exec { 'build-script':
      cwd         => '/usr/share/kiwiirc',
      command     => '/usr/share/kiwiirc/kiwi build',
      creates     => '/usr/share/kiwiirc/client/assets/kiwi.js',
      require     => [ Exec['npm-install'], File['/usr/share/kiwiirc/config.js'] ]
    }

  vcsrepo { '/usr/share/kiwiirc':
      ensure   => present,
      provider => git,
      source   => 'https://github.com/prawnsalad/KiwiIRC.git',
      #revision => '0.9.3',
      require  => [ File['/usr/share/kiwiirc'], Package['git'] ],
      notify   => [ Exec['build-script'], ]
    }
}
