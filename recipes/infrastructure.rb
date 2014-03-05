node['operations']['infrastructure']['packages'].each do |p|
  Chef::Log.info "Downloading and Installing Dependency: #{p}"
  package p
end

node['operations']['infrastructure']['pip_packages'].each do |p|
  Chef::Log.info "Downloading and Installing Dependency: #{p}"
  python_pip p
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

git '/opt/anthracite' do
  repository "https://github.com/Dieterbe/anthracite.git"
  reference "master"
  action :sync
end

cron_d 'snapshot-backup' do
  minute  0
  hour    "*"
  command 'python /usr/bin/snapshot-create Name operations 72 /opt sdh1 "/usr/sbin/xfs_freeze -f" "/usr/sbin/xfs_freeze -u"'
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

package node['mongodb']['package_name'] do
  action :install
  version node['mongodb']['package_version']
end

service "mongod" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

git '/opt/skyline' do
  repository "https://github.com/etsy/skyline.git"
  reference "master"
  action :sync
end

script "install-skyline-prereqs" do
  not_if { File.exists?("/var/log/skyline") }
  interpreter "bash"
  user "root"
  group "root"
  cwd "/tmp"
  code <<-EOH
  cd /opt/skyline
  pip install -r requirements.txt
  mkdir -p /var/log/skyline
  mkdir -p /var/run/skyline
  mkdir -p /var/log/redis
  mkdir -p /var/dump/
  EOH
end

template "/opt/skyline/src/settings.py" do
  source "skyline-settings.py.erb"
  owner "root"
  group "root"
  variables()
end
  
script "run-skyline" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
  cd /opt/skyline/bin
  ./horizon.d start
  ./analyzer.d start
  ./webapp.d start
  EOH
end

git '/opt/seyren' do
  repository "https://github.com/scobal/seyren.git"
  reference "master"
  action :sync
end

script "install-seyren" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
  cd /opt/seyren
  mvn clean package
  GRAPHITE_URL=#{node['seyren']['graphite_url']} SEYREN_URL=http://localhost:#{node['seyren']['listen_port']}/seyren java -jar seyren-web/target/dependency/jetty-runner.jar --port #{node['seyren']['listen_port']} --path /seyren seyren-web/target/*.war &
  EOH
end