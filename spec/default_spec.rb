# Encoding: utf-8

require_relative 'spec_helper'

describe 'operations::default' do
  
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic['memory']['total'] = '8388608kB'
    end.converge(described_recipe)
  end
  
  describe 'centos' do
    
    before do
      stub_command("sudo -V").and_return("Sudo version 1.8.6p3")
      @chef_run = ::ChefSpec::Runner.new(::CENTOS_OPTS)
      stub_resources
      @chef_run.converge 'operations::default'
    end

    %w{ user yum yum-epel cron rsyslog git python graphite sudo redisio java postfix mysql statsd elasticsearch nginx kibana jenkins logstash chatbot }.each do |cb|
      it "includes the #{cb} recipe" do
        expect(@chef_run).to include_recipe(cb)
      end
    end
 
  end
end