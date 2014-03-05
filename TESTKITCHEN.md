```bash
apt-get install ruby-dev
git clone git://github.com/Jumpshot/operations.git
cd operations
bundle install
kitchen converge
```

Port forwarding is configured for: http://localhost:8000 on the HOST. Edit your /etc/hosts for testing virtualhosts.
```bash
127.0.0.1 graphite.internal.operations.com anthracite.internal.operations.com seyren.internal.operations.com skyline.internal.operations.com jenkins.internal.operations.com
```

Unit and Integration tests can be run by using the `kitchen test` command.

You can then SSH into the running VM using the `kitchen login` command.

The VM can easily be stopped and deleted with the `kitchen destroy` command.

Please see the official [Test Kitchen](http://kitchen.ci/docs/getting-started/) for a more in depth explanation of available commands.
