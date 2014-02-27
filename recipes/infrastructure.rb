node['operations']['infrastructure']['packages'].each do |p|
  Chef::Log.info "Downloading and Installing Dependency: #{p}"
  package p
end

Array(node['nginx']['sites']['proxy']).each do |u|

  Chef::Log.info "Generating site configuration for: " << u['domain']

  template "/etc/nginx/sites-enabled/#{u['domain']}.conf" do
    source "infra-nginx-proxy.erb"
    owner "root"
    group "root"
    variables(
    :directory => u['directory'],
    :domain => u['domain'],
    :proxy_location => u['proxy_location']||''
    )
    notifies :restart, "service[nginx]"
  end
  
end

template "/etc/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  variables()
  notifies :restart, "service[redis6379]",  :delayed
  notifies :restart, "service[logstash_server]", :delayed
end

git '/opt/anthracite' do
  repository "https://github.com/Dieterbe/anthracite.git"
  reference "master"
  action :sync
end

cron_d 'snapshot-backup' do
  minute  0
  hour    "*"
  command 'python /usr/bin/snapshot-create Name infrastructure 72 /opt sdh1 "/usr/sbin/xfs_freeze -f" "/usr/sbin/xfs_freeze -u"'
  user    'root'
end


###################################################################################
# New Tool Testing
# MongoDB Cookbook dosn't support Yum 3.0 or Chef 11 yet, but we're not using it
# for anything other than metadata, so it really dosnt matter.
yum_repository '10gen' do
  description '10gen RPM Repository'
  baseurl "http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/"
  action :create
  gpgcheck false
end

user_account 'mongod' do
  comment       'MongoDB User'
  ssh_keygen    false
  manage_home   false
end

package node[:mongodb][:package_name] do
  action :install
  version node[:mongodb][:package_version]
end

service "mongod" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

script "install-skyline-prereqs" do
  not_if { File.exists?("/usr/lib/python2.6/site-packages/scikits") }
  interpreter "bash"
  user "root"
  group "root"
  cwd "/tmp"
  code <<-EOH
  mkdir -p /var/log/skyline
  mkdir -p /var/run/skyline
  mkdir -p /var/log/redis
  mkdir -p /var/dump/
  pip install scikits.statsmodels
  pip install scipy 
  pip install pandas
  pip install patsy
  pip install statsmodels
  pip install msgpack_python
  EOH
end