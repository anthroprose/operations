default['operations']['ssh_keys'] = ['']
default['operations']['user'] = 'operations'

default['operations']['packages'] = %w{
  python-devel
  libxml2-devel
  libxslt-devel
}

default['operations']['pip_packages'] = %w{
  configobj==4.6.0
  http://argparse.googlecode.com/files/argparse-1.2.1.tar.gz
  beaver==31
  python-statsd==1.6.2
}

default['operations']['infrastructure']['packages'] = %w{
  htop
  memcached
  fuse
  rubygems
  ruby-devel
}

default['operations']['infrastructure']['pip_packages'] = %w{
}

default['mysql']['server']['packages'] = ['mysql-server']