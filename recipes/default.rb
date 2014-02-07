Array(node['dependencies']).each do |p|
  
  Chef::Log.info "Downloading and Installing Dependency: #{p}"
  
  package p do
    action :install
  end
  
end

user_account node["operations"]["user"] do
  comment       'Administrative User'
  ssh_keygen    true
  home          '/home/#{node["operations"]["user"]}'
  manage_home   true
  ssh_keys node["operations"]["ssh_keys"]
end

script "install-diamond" do
  not_if { File.exists?("/etc/diamond/diamond.conf") }
  interpreter "bash"
  user "root"
  group "root"
  cwd "/tmp"
  code <<-EOH
    git clone https://github.com/BrightcoveOS/Diamond.git
    cd Diamond
    make install
  EOH
end

execute "restart-diamond-config" do
  command "killall -9 diamond;diamond -c /etc/diamond/diamond.conf"
  action :nothing
end

template "/etc/diamond/diamond.conf" do
  source "diamond.conf.erb"
  owner "root"
  group "root"
  variables()
  notifies :run, "execute[restart-diamond-config]", :immediately
end

script "install-beaver" do
  not_if { File.exists?("/etc/beaver/beaver.conf") }
  interpreter "bash"
  user "root"
  group "root"
  cwd "/tmp"
  code <<-EOH
    pip install beaver==31
    mkdir -p /etc/beaver
  EOH
end

execute "restart-beaver-config" do
  command "killall -9 beaver;beaver -c /etc/beaver/beaver.conf -D -P /var/run/beaver.pid -F json"
  action :nothing
end

template "/etc/beaver/beaver.conf" do
  source "beaver.conf.erb"
  owner "root"
  group "root"
  variables()
  notifies :run, "execute[restart-beaver-config]", :immediately
end