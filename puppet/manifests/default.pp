$home = '/home/vagrant'
$ruby_version = '2.1.2'

Exec {
  path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}

# --- Preinstall ---------------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt get update':
    user => 'root',
    command => 'apt-get -y update',
    unless => "test -e ${home}/.rbenv"
  }
}

class { 'apt_get_update':
  stage => preinstall
}

# --- Packages -----------------------------------------------------------------

package { 'git-core':
  ensure => installed
}

package { 'libssl-dev':
  ensure => installed
}

# --- Ruby ---------------------------------------------------------------------

exec { 'install rbenv':
  command => "git clone https://github.com/sstephenson/rbenv.git ${home}/.rbenv",
  creates => "${home}/.rbenv",
  require => Package['git-core', 'libssl-dev']
}

exec { 'install ruby-build':
  command => "git clone https://github.com/sstephenson/ruby-build.git ${home}/.rbenv/plugins/ruby-build",
  creates => "${home}/.rbenv/plugins/ruby-build",
  require => Exec['install rbenv']
}

exec { 'install ruby':
  command => "${home}/.rbenv/plugins/ruby-build/bin/ruby-build ${ruby_version} ${home}/.rbenv/versions/${ruby_version}",
  creates => "${home}/.rbenv/versions/${ruby_version}",
  require => Exec['install ruby-build'],
  timeout => 900 # 15 minutes
}

file { 'set global ruby':
  content => "${ruby_version}",
  ensure => file,
  path => "${home}/.rbenv/version"
}
