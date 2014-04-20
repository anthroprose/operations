require 'chef/log'

module Opscode
  class OperationsHandler < Chef::Handler

    def data
      @run_status.to_hash
    end

    def report
      @run_status = run_status
      Chef::Log.info("Operations Report Handler - Updated Resources: " + @run_status.updated_resources.count.to_s)
    end
  end
end