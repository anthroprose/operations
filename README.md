operations
==========

![Travis-CI Build Status](https://api.travis-ci.org/Jumpshot/operations.png)

Chef Cookbook for a single stack operations machine.

This cookbook and associated role & metadata are currently tuned for a (we started with a c3.large with 2 cores and 3.75G of RAM) are are now using a m3.xlarge with 4cores and 15G of RAM (ElasticSearch some extra headroom to cover large log bursts of the half mill per minute variety and statsD with node eats CPU). In production we are capable of aggregating logs, indexing and serving live analytics for approximately 40,000 Transactions Per Minute of our Web App, which can be anywhere from 3 - 6 log lines per request (NginX, uWSGI, App) (anywhere from 250,000 to 500,000 loglines per minute at peak!). Additionally, and approximately 5,000,000 (yeah, thats Millions) time series datapoints are aggregated and written every minute from diamond and statsD calls in the codebase.

No special tuning has occured, and we are using standard EBS, no PIOPs or kernel settings at this point. We're thinking about switching to https://github.com/armon/statsite or https://github.com/bitly/statsdaemon for a less CPU intensive statsD daemon (it currently uses more CPU than ElasticSearch, Carbon or Logstash).

Included is a cloudformation template which will setup a 1:1 Min/Max ASG for garunteeing uptime of the instance. All data is stored under /opt which is an EBS Mountpoint in AWS. Snapshots are taken every hour and on boot/reboot the machine checks for old snapshots to mount under /opt instead of re-installing or re-creating the drive.  At most you may loose up to 1 hour of data with this setup, small gaps in graphs. 

# Log Aggregation/Analysis
* ElasticSearch
* Logstash
* Kibana
* Rsyslog
* Redis
* Beaver

# Time Series / Metrics
* Graphite
* StatsD
* Tattle (probably going to replace with seyren)
* Skyline (In Progress)

# Continuous Integration / Delivery
* Jenkins
* Test Kitchen (In Progress)

--------------------------------------------------------------------------------------

## Changelog

* Read the [Changelog](CHANGELOG.md)

## Test Kitchen
* Read the [Test Kitchen](TESTKITCHEN.md) Readme

## AWS
* Coming soon

--------------------------------------------------------------------------------------

Requirements
------------
* CentOS/RHEL/Amazon Linux

#### packages
- `rubygems` - chef, and gems
- `ruby-devel` - for compiling and installing gems
- `numpy` - for crunching stats

#### pip packages
- `beaver==31` - Log shipping
- `flask` - lightweight web framework
- `grequests` - gevent async http
- `scikits.statsmodels` - stats
- `scipy` - stats
- `pandas` - data structures
- `patsy` - statistical models
- `statsmodels` - statistical models
- `msgpack_python` - serialization
- `boto` - api calls

#### rubygems
- `chef-zero` - mock all the things
- `test-kitchen` - test all the things
- `kitchen-ec2` - test all the things in the cloud

#### chef cookbooks
- `recipe[yum]` - packages
- `recipe[user]` - users
- `recipe[cron]` - crontabs
- `recipe[rsyslog::client]` - log aggregation
- `recipe[git]` - code checkout
- `recipe[chef-solo-search]` - if not using chef server
- `recipe[graphite]` - time series graphing
- `recipe[sudo]` - users
- `recipe[redis]` - log aggregation queue
- `recipe[java]` - all the things
- `recipe[postfix]` - alerting
- `recipe[mysql::server]` - metadata storage
- `recipe[logstash::server]` - log aggregation
- `recipe[statsd]` - time series data
- `recipe[elasticsearch]` - log aggregation and document store
- `recipe[nginx]` - http(s)
- `recipe[kibana]` - log aggregation visualization
- `recipe[jenkins::server]` - continuous integration/delivery
- `recipe[chatbot]` - hipchat v2 api bot
- `recipe[chatbot::init]` - init.d for bot

#### projects
- [diamond](https://github.com/BrightcoveOS/Diamond) - metrics & monitoring
- [beaver](https://github.com/josegonzalez/beaver) - log shipping
- [anthracite](https://github.com/Dieterbe/anthracite) - event annotation for metrics
- [tattle](https://github.com/wayfair/Graphite-Tattle) - alerting for graphite
- [aws-minions](https://github.com/Jumpshot/aws-minions) - snapshot backups & restores, dynamic dns

#### to consider
- [seyren](https://github.com/scobal/seyren) - better alerting than tattle
- [skyline](https://github.com/etsy/skyline) - anomaly detection
- [test kitchen](https://github.com/test-kitchen/test-kitchen) - chef continuous integration
- [revily](https://github.com/revily/revily) - On-call scheduling and incident response

Attributes
----------
#### operations::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['operations']['user']</tt></td>
    <td>String</td>
    <td>system account</td>
    <td><tt>operations</tt></td>
  </tr>
  <tr>
    <td><tt>['operations']['ssh_keys']</tt></td>
    <td>String Set [Array]</td>
    <td>public ssh keys for system account's autorized_keys</td>
    <td><tt>["","",""]</tt></td>
  </tr>
  <tr>
    <td><tt>['rsyslog']['server_ip']</tt></td>
    <td>String</td>
    <td>syslog server for rsyslog forwarding</td>
    <td><tt>syslog.internal.operations.com</tt></td>
  </tr>
  <tr>
    <td><tt>['rsyslog']['port']</tt></td>
    <td>Integer</td>
    <td>syslog port for rsyslog forwarding</td>
    <td><tt>5544</tt></td>
  </tr>
  <tr>
    <td><tt>['logstash']['server']['base_config_cookbook']</tt></td>
    <td>String</td>
    <td>cookbook with logstash server config template</td>
    <td><tt>operations</tt></td>
  </tr>
  <tr>
    <td><tt>['logstash']['server']['install_rabbitmq']</tt></td>
    <td>Boolean</td>
    <td>to install rabbitmq or not</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['logstash']['server']['xmx']</tt></td>
    <td>String</td>
    <td>java max ram</td>
    <td><tt>512M</tt></td>
  </tr>
  <tr>
    <td><tt>['logstash']['server']['xms']</tt></td>
    <td>String</td>
    <td>java min ram</td>
    <td><tt>512M</tt></td>
  </tr>
  <tr>
    <td><tt>['statsd']['delete_idle_stats']</tt></td>
    <td>Boolean</td>
    <td>delete idle stats</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['statsd']['delete_timers']</tt></td>
    <td>Boolean</td>
    <td>delete idle timers</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['statsd']['delete_gauges']</tt></td>
    <td>Boolean</td>
    <td>delete idle gauges</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['statsd']['delete_sets']</tt></td>
    <td>Boolean</td>
    <td>delete idle sets</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['statsd']['delete_counters']</tt></td>
    <td>Boolean</td>
    <td>delete idle counters</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['statsd']['flush_interval']</tt></td>
    <td>Integer</td>
    <td>flush interval in ms - set this the same as diamond! (1 minute here)</td>
    <td><tt>60000</tt></td>
  </tr>
  <tr>
    <td><tt>['authorization']['sudo']['passwordless']</tt></td>
    <td>Boolean</td>
    <td>allow passwordless sudo</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['authorization']['sudo']['users']</tt></td>
    <td>String Set [Array]</td>
    <td>list of users to allow sudo access</td>
    <td><tt>["ec2-user", "operations"]</tt></td>
  </tr>
  <tr>
    <td><tt>['postfix']['main']['smtpd_use_tls']</tt></td>
    <td>Boolean</td>
    <td>use tls when connecting out</td>
    <td><tt>false</tt></td>
  </tr>  
  <tr>
    <td><tt>['tattle']['listen_port']</tt></td>
    <td>Integer</td>
    <td>port for tattle webapp</td>
    <td><tt>8082</tt></td>
  </tr>
  <tr>
    <td><tt>['tattle']['url']</tt></td>
    <td>String</td>
    <td>url for alert emails to link back</td>
    <td><tt>tattle.internal.operations.com</tt></td>
  </tr>
  <tr>
    <td><tt>['tattle']['admin_email']</tt></td>
    <td>String</td>
    <td>email alerts are from</td>
    <td><tt>ops@operations.com</tt></td>
  </tr>
  <tr>
    <td><tt>['tattle']['doc_root']</tt></td>
    <td>String</td>
    <td>docroot for tattle webapp</td>
    <td><tt>/opt/tattle</tt></td>
  </tr>
  <tr>
    <td><tt>['chatbot']['rooms']</tt></td>
    <td>String Set [Array]</td>
    <td>list of hipchat rooms to join</td>
    <td><tt>["alpha", "names"]</tt></td>
  </tr>
  <tr>
    <td><tt>['chatbot']['username']</tt></td>
    <td>String</td>
    <td>hipchat account username</td>
    <td><tt>realname</tt></td>
  </tr>
  <tr>
    <td><tt>['chatbot']['password']</tt></td>
    <td>String</td>
    <td>hipchat password</td>
    <td><tt>xx</tt></td>
  </tr>
  <tr>
    <td><tt>['chatbot']['nickname']</tt></td>
    <td>String</td>
    <td>nickname for bot</td>
    <td><tt>eggdrop</tt></td>
  </tr>
  <tr>
    <td><tt>['chatbot']['api_key']</tt></td>
    <td>String</td>
    <td>v2 api key</td>
    <td><tt>md5</tt></td>
  </tr>
  <tr>
    <td><tt>['nginx']['default_domain']</tt></td>
    <td>String</td>
    <td>default vhost listener</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>['nginx']['default_site_enabled']</tt></td>
    <td>Boolean</td>
    <td>allow default docroot</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['nginx']['sites']['proxy']</tt></td>
    <td>String Set [Array of {Object}]</td>
    <td>snazzy nginx proxy metadata</td>
    <td><tt>[
				{ "domain":"graphite.internal.operations.com", "directory":"/opt/graphite/webapp/content/", "proxy_location" : "http://localhost:8080" },
				{ "domain":"anthracite.internal.operations.com", "directory":"/opt/anthracite/", "proxy_location" : "http://localhost:8081" },
				{ "domain":"tattle.internal.operations.com", "directory":"/opt/tattle/", "proxy_location" : "http://localhost:8082" },
				{ "domain":"skyline.internal.operations.com", "directory":"/opt/skyline/", "proxy_location" : "http://localhost:1500" },
			 	{ "domain":"jenkins.internal.operations.com", "directory":"/opt/jenkins/", "proxy_location" : "http://localhost:8089" }
			]
	</tt></td>
  </tr>
  <tr>
    <td><tt>['nginx']['default_site_enabled']</tt></td>
    <td>Boolean</td>
    <td>allow default docroot</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['apache']['listen_ports']</tt></td>
    <td>Integer [Array]</td>
    <td>ports that apache can vhost listen on</td>
    <td><tt>8080</tt></td>
  </tr>
  <tr>
    <td><tt>['graphite']['listen_port']</tt></td>
    <td>Integer</td>
    <td>graphite vhost listener</td>
    <td><tt>8080</tt></td>
  </tr>
  <tr>
    <td><tt>['graphite']['graphite_web']['bitmap_support']</tt></td>
    <td>Boolean</td>
    <td>compile fancy bitmap support</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['kibana']['webserver_hostname']</tt></td>
    <td>String</td>
    <td>hostname for kibana</td>
    <td><tt>kibana.internal.operations.com</tt></td>
  </tr>
  <tr>
    <td><tt>['kibana']['webserver_listen']</tt></td>
    <td>String</td>
    <td>ip to bind to</td>
    <td><tt>*</tt></td>
  </tr>
  <tr>
    <td><tt>['elasticsearch']['allocated_memory']</tt></td>
    <td>String</td>
    <td>ram for elasticsearch</td>
    <td><tt>2048m</tt></td>
  </tr>
  <tr>
    <td><tt>['elasticsearch']['version']</tt></td>
    <td>String</td>
    <td>version to install</td>
    <td><tt>0.90.11</tt></td>
  </tr>
  <tr>
    <td><tt>['elasticsearch']['path']['data']</tt></td>
    <td>String</td>
    <td>path to data store</td>
    <td><tt>/opt/elasticsearch/data</tt></td>
  </tr>
  <tr>
    <td><tt>['elasticsearch']['path']['work']</tt></td>
    <td>String</td>
    <td>path to work store</td>
    <td><tt>/opt/elasticsearch/work</tt></td>
  </tr>
  <tr>
    <td><tt>['elasticsearch']['path']['logs']</tt></td>
    <td>String</td>
    <td>path to logs</td>
    <td><tt>/var/log/elasticsearch</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql']['server_debian_password']</tt></td>
    <td>String</td>
    <td>another password for mysql</td>
    <td><tt>xx</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql']['server_repl_password']</tt></td>
    <td>String</td>
    <td>root password for mysql</td>
    <td><tt>xx</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql']['server_root_password']</tt></td>
    <td>String</td>
    <td>another password for mysql</td>
    <td><tt>xx</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkins']['server']['port']</tt></td>
    <td>Integer</td>
    <td>port jenkins lives on</td>
    <td><tt>8089</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkins']['server']['home']</tt></td>
    <td>String</td>
    <td>data dir</td>
    <td><tt>/opt/jenkins</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkins']['server']['url']</tt></td>
    <td>String</td>
    <td>url for jenkins</td>
    <td><tt>http://jenkins.internal.operations.com</tt></td>
  </tr>
</table>

Features/Usage
----------
#### operations::default

* Include this on any node for all of the pre-reqs for log and metrics shipping
* Just set: ```"rsyslog" => { "server_ip" => "syslog.internal.operations.com", "port" => "5544" }```

#### operations::infrastructure
* Some attributes *must* be overriden, not defaulted. Check the role json, we use this because of setting and over-riding attributes across a large number of cookbooks.
* If using AWS, it self-snapshots the /opt mounted EBS once an hour by freezing the XFS filesystem, snapshotting and then thawing the drive.
* If using AWS, it uses UserData to check for previous snapshots and loads the latest one instead of creating a new /opt mount (bounce-back servers! you loose up to 1 hour of data/gaps in graphs with this)
* Log Aggregation/Indexing/Querying for your entire Infrastructure
* Time Series data collection and graphing
* Event annotation for tracking operation events such as deploys/downtime along with graphs
* Alerting for Time Series Data
* Jenkins for reporting on timed/cron'd operational tasks or actually used for continuous integration/delivery

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: corley@avast.com - [anthroprose](https://github.com/anthroprose)