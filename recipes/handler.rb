include_recipe "chef_handler"

cookbook_file "#{node["chef_handler"]["handler_path"]}/operations.rb" do
  source "chef_handler-operations.rb"
  owner "root"
  group "root"
  mode 00755
  action :create
end

chef_handler "Opscode::OperationsHandler" do
  source "#{node["chef_handler"]["handler_path"]}/operations.rb"
  supports :report => true
  action :enable
end