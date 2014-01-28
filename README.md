operations
==========

Chef Cookbook for a single stack operations machine.


Requirements
------------
* CentOS/RHEL/Amazon Linux

#### packages
- `rubygems` - chef, and gems
- `ruby-devel` - for compiling and installing gems
- `numpy` - for crunching stats

#### pip packages
- `beaver==30` - This should really be 31, but its better than running master from github currently
- `flask` - lightweight web framework
- `grequests` - gevent async http
- `scikits.statsmodels` - stats
- `scipy` - stats
- `pandas` - data structures
- `patsy` - statistical models
- `statsmodels` - statistical models
- `msgpack_python` - serialization

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
- `recipe[chatbot]` - serialization
- `recipe[chatbot::init]` - serialization

#### projects
- `[diamond](https://github.com/BrightcoveOS/Diamond)` - metrics & monitoring
- `[beaver](https://github.com/josegonzalez/beaver)` - log shipping
- `[anthracite](https://github.com/Dieterbe/anthracite)` - event annotation for metrics
- `[tattle](https://github.com/wayfair/Graphite-Tattle)` - alerting for graphite
- `[aws-minions](https://github.com/Jumpshot/aws-minions)` - snapshot backups & restores, dynamic dns


#### to consider
- `[seyren](https://github.com/scobal/seyren)` - better alerting than tattle


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
    <td><tt>256M</tt></td>
  </tr>
  <tr>
    <td><tt>['logstash']['server']['xms']</tt></td>
    <td>String</td>
    <td>java min ram</td>
    <td><tt>256M</tt></td>
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
    <td><tt>kibana.internal.jumpshot.com</tt></td>
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
    <td><tt>512m</tt></td>
  </tr>
  <tr>
    <td><tt>['elasticsearch']['version']</tt></td>
    <td>String</td>
    <td>version to install</td>
    <td><tt>0.90.7</tt></td>
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

Usage
-----
#### opstest::default
TODO: Write usage instructions for each cookbook.

Some attributes *must* be overriden, not defaulted. Check the role json.

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
