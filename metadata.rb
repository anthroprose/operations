# Encoding: utf-8
name             'operations'
maintainer       'Alex Corley'
maintainer_email 'corley@avast.com'
license          'GPLv2'
description      'Installs/Configures a Single Stack Operations Machine'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'
recipe           'operations', 'Installs everything for shipping metrics & logs.'
recipe           'operations::infrastructure', 'Installs/Configures the Log Aggregating/Indexing/Querying Machine'

%w{ amazon centos fedora redhat scientific }.each do |os|
  supports os
end

%w{ user yum yum-epel cron rsyslog git python graphite sudo redisio java maven postfix mysql statsd elasticsearch nginx kibana jenkins logstash chatbot }.each do |cb|
  depends cb
end