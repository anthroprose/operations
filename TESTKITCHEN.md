```bash
apt-get install ruby-dev
gem install test-kitchen
git clone git://github.com/Jumpshot/operations.git
cd operations
kitchen test
```

You can then SSH into the running VM using the `kitchen login` command.

The VM can easily be stopped and deleted with the `kitchen destroy` command.

Please see the official [Test Kitchen](http://kitchen.ci/docs/getting-started/) for a more in depth explanation of available commands.
