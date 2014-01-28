# Encoding: utf-8
name             'operations'
maintainer       'Alex Corley'
maintainer_email 'corley@avast.com'
license          'Apache 2.0'
description      'Installs/Configures operations'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ centos }.each do |os|
  supports os
end

depends "yum"