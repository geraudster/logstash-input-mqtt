# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/inputs/mqtt"

describe LogStash::Inputs::Mqtt do

  it_behaves_like "an interruptible input plugin" do
    let(:config) { { "broker_host" => "localhost" } }
  end

end
