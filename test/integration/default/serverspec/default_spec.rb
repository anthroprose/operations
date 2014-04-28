# Encoding: utf-8
require_relative 'spec_helper'

describe service('nginx') do
  it { should be_enabled   }
  it { should be_running   }
end

describe service('httpd') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(80) do
  it { should be_listening }
end

describe service('elasticsearch') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(9200) do
  it { should be_listening }
end

describe service('logstash_server') do
  it { should be_enabled   }
  it { should be_running   }
end

describe service('redis6379') do
  it { should be_enabled   }
  it { should be_running   }
end

# statsD Does not support chkconfig status
#describe service('statsd') do
#  it { should be_enabled   }
#  it { should be_running   }
#end

describe service('carbon-cache') do
  it { should be_enabled   }
  it { should be_running   }
end

describe service('mongod') do
  it { should be_enabled   }
  it { should be_running   }
end