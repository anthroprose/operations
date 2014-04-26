continuous operations
==========

[![Travis-CI Build Status](https://api.travis-ci.org/Jumpshot/operations.png)](https://travis-ci.org/Jumpshot/operations) [![Dependency Status](https://gemnasium.com/Jumpshot/operations.png)](https://gemnasium.com/Jumpshot/operations) [![Gitter chat](https://badges.gitter.im/Jumpshot/operations.png)](https://gitter.im/Jumpshot/operations)

## v1.0.0

Chef Cookbook for a single stack operations machine.

This cookbook and associated role & metadata are currently tuned for a (we started with a c3.large with 2 cores and 3.75G of RAM) however are now using a m3.xlarge with 4cores and 15G of RAM (ElasticSearch some extra headroom to cover large log bursts of the half mill per minute variety and statsD with node eats CPU).
In production we are capable of aggregating logs, indexing and serving live analytics for approximately 40,000 Transactions Per Minute of our Web App, which can be anywhere from 3 - 6 log lines per request (NginX, uWSGI, App) (anywhere from 250,000 to 500,000 loglines per minute at peak!).
Additionally, and approximately 5,000,000 (yeah, thats Millions) commited time series datapoints are aggregated and written across a few thousand metrics every minute from diamond and statsD calls in the codebase.

The only thing besides verticle scaling that has occured is switching to PIOPs (500 IOPs). We're thinking about switching to https://github.com/armon/statsite or https://github.com/bitly/statsdaemon for a less CPU intensive statsD daemon (it currently uses more CPU than ElasticSearch, Carbon or Logstash).

Included is a CloudFormation template which will setup a 1:1 Min/Max ASG for guaranteeing uptime of the instance. All data is stored under /opt which is an EBS Mountpoint in AWS. Snapshots are taken every hour and on boot/reboot the machine checks for old snapshots to mount under /opt instead of re-installing or re-creating the drive. At most you may loose up to 1 hour of data with this setup, small gaps in graphs. 

# Log Aggregation/Analysis
* ElasticSearch v1.1.0
* Logstash v1.4.0
* Kibana
* Rsyslog
* Redis
* Beaver

# Time Series / Metrics
* Graphite v0.9.10
* StatsD
* Seyren

# Continuous Integration / Delivery
* Jenkins
* Chef DK
* Test Kitchen

# Infrastructure Reporting
* Netflix's ICE for AWS Billing & Usage Reporting

## AWS
* CloudFormation Templates for Networking
* VPN Machine
* CloudWatch Metrics Insertion
* CloudWatch Alert Processing

--------------------------------------------------------------------------------------

## Changelog

* Read the [Changelog](CHANGELOG.md)

## Test Kitchen
* Read the [Test Kitchen](TESTKITCHEN.md) Readme

--------------------------------------------------------------------------------------

Requirements
------------
* CentOS/RHEL/Amazon Linux

#### packages
- `rubygems` - chef, and gems
- `ruby-devel` - for compiling and installing gems

#### pip packages
- `beaver==31` - Log shipping
- `flask` - lightweight web framework
- `grequests` - gevent async http
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
- `recipe[redisio]` - log aggregation queue
- `recipe[java]` - all the things
- `recipe[maven]` - for building seyren
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
- [seyren](https://github.com/scobal/seyren) - better alerting than tattle
- [aws-minions](https://github.com/Jumpshot/aws-minions) - snapshot backups & restores, dynamic dns
- [test kitchen](https://github.com/test-kitchen/test-kitchen) - chef continuous integration
- [ice](https://github.com/Netflix/ice) - aws billing reports

#### to consider
- [revily](https://github.com/revily/revily) - On-call scheduling and incident response

Features/Usage
----------

#### Notes
* This is currently being refactored into a wrapper cookbook and the role is going away!

#### operations::handler
* Include this on any node for Chef report_handler and exception_handler functionality (Important for ASG!)
* Can also be run with chef-client -o for continuous acceptance/integration tests for live nodes

#### operations::default
* Include this on any node for all of the pre-reqs for log and metrics shipping
* Just set: ```"rsyslog" : { "server_ip" : "syslog.internal.operations.com", "port" : "5544" }```

#### operations::infrastructure
* Some attributes *must* be overriden, not defaulted. Check the role json, we use this because of setting and over-riding attributes across a large number of cookbooks.
* If using AWS, it self-snapshots the /opt mounted EBS once an hour by freezing the XFS filesystem, snapshotting and then thawing the drive.
* If using AWS, it uses UserData to check for previous snapshots and loads the latest one instead of creating a new /opt mount (bounce-back servers! you loose up to 1 hour of data/gaps in graphs with this)
* Log Aggregation/Indexing/Querying for your entire Infrastructure
* Time Series data collection and graphing
* Event annotation for tracking operation events such as deploys/downtime along with graphs
* Alerting for Time Series Data
* Jenkins for reporting on timed/cron'd operational tasks or actually used for continuous integration/delivery


Notes for Scale
------------
* If you are running redis 2.4.x increase the ulimit or upgrade to 2.6.x, running out of file descriptors will cause 100% CPU and a non-responsive redis [reference](http://code.google.com/p/redis/issues/detail?id=648)
* node.js statsD is the highest CPU User, consider running a C version
* If using AWS, just go ahead and use PIOPs on a single mountpoint to start, you can always adjust the throughput, but you will hit a ceiling of <500,000.00 log lines and <100,000.00 time series metrics per minute at the standard ~100IOPS for EBS 
* If using Public Cloud Services like S3, SQS, DDB, etc... enable EIPs for *ALL* ASGs otherwise you will saturate your NAT. (ELB, RDS, ElastiCache are all intra-VPC and OK)
* Removed Skyline from the project, it just needs to run on its own machine

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