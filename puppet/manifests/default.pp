$ruby_version = '2.1.2'

# --- Ruby ---------------------------------------------------------------------

class { 'rbenv': }

rbenv::plugin { 'sstephenson/ruby-build': }

rbenv::build { "${ruby_version}":
  global => true
}

rbenv::gem { 'rails':
  ruby_version => "${ruby_version}",
  skip_docs => true,
  timeout => 1800
}

rbenv::gem { 'foreman':
  ruby_version => "${ruby_version}",
  skip_docs => true
}

# --- PostgreSQL ---------------------------------------------------------------

class { 'postgresql::server': }
