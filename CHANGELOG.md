operations CHANGELOG
====================

This file is used to list changes made in each version of the operations cookbook.

0.2.0
-----
- [anthroprose] - Replaced Tattle with Seyren, also have a running Skyline
- [anthroprose] - Lots of updates for the Yum 3.x cookbook line
- [anthroprose] - Added Netflix's ICE to a seperate Cloudformation Template
- [anthroprose] - Switched to Redis 2.6.x via redisio cookbook instead of epel packages

0.1.3
-----
- [anthroprose] - Better test-kitchen documentation and Gemfile updates for lots of version pins (no functional changes)

0.1.2
-----
- [anthroprose] - Switching to using test-kitchen as vagrant-berkshelf is being deprecated
- [anthroprose] - Switched to redisio cookbook as its supported
- [anthroprose] - Fixed some notify code and git checkouts to not upset foodcritic
- [anthroprose] - Added a couple serverspec tests to verify running services and port availability

0.1.1
-----
- [anthroprose] - Working Vagrantfile, better documentation, seperated basic metric/log shipping dependencies from everything else

0.1.0
-----
- [anthroprose] - Initial release of operations

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
