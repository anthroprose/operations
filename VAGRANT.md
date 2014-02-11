Here's how you can quickly get testing or developing against the cookbook thanks to [Vagrant](http://vagrantup.com/) and [Berkshelf](http://berkshelf.com/).

```bash
apt-get install ruby-dev
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-chef-zero
git clone git://github.com/Jumpshot/operations.git
cd operations
vagrant up
```

You can then SSH into the running VM using the `vagrant ssh` command.

The VM can easily be stopped and deleted with the `vagrant destroy` or `vagrant destroy -f` command. Please see the official [Vagrant documentation](http://docs.vagrantup.com/v2/cli/index.html) for a more in depth explanation of available commands.

You can access the virtualhosts by editing your local hosts file, or CNAME'n them all using Route53 or other DNS.