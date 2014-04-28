# Encoding: utf-8
name             'operations'
maintainer       'Alex Corley'
maintainer_email 'corley@avast.com'
license          'GPLv2'
description      'Installs/Configures a Single Stack Operations Machine'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'
recipe           'operations', 'Installs everything for shipping metrics & logs.'
recipe           'operations::handler', 'Chef Report & Exception Handler'
recipe           'operations::infrastructure', 'Installs/Configures the Log Aggregating/Indexing/Querying Machine'

%w{ amazon centos fedora redhat scientific }.each do |os|
  supports os
end

depends "nginx", "= 2.2.0" 

%w{ user yum-epel yum cron rsyslog git python graphite sudo redisio java maven postfix mysql statsd elasticsearch kibana jenkins logstash chef_handler chatbot }.each do |cb|
  depends cb
end