# Encoding: utf-8
name             'operations'
maintainer       'Alex Corley'
maintainer_email 'corley@avast.com'
license          'GPLv2'
description      'Installs/Configures a Single Stack Operations Machine'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ centos }.each do |os|
  supports os
end

%w{ yum user cron rsyslog git graphite sudo redis java postfix mysql logstash statsd elasticsearch nginx kibana jenkins chatbot }.each do |cb|
  depends cb
end