# encoding: utf-8
require "logstash/inputs/base"
require "logstash/namespace"
require "socket" # for Socket.gethostname
require "mqtt"

# Receive events from a MQTT topic

class LogStash::Inputs::Mqtt < LogStash::Inputs::Base
  config_name "mqtt"

  #
  # Codecs are used to turn message strings into message objects.
  # Useful codecs might be json, or protobuf
  #
  default :codec, "plain"

  # The host of the MQTT broker
  config :broker_host, :validate => :string, :default => "192.168.1.20"
  
  # The port that the MQTT broker is using
  config :broker_port, :validate => :number, :default => 1883
  
  # Whether connection to the MQTT broker is using SSL or not.
  config :ssl, :validate => :boolean, :default => false

  # The username for the MQTT connection
  config :username, :validate => :string, :default => nil

  # The password for the MQTT connection
  config :password, :validate => :string, :default => nil

  # The host of the MQTT broker
  config :client_id, :validate => :string, :default => MQTT::Client.generate_client_id("logstash-mqtt-input", 4)

  # Whether or not to use a clean session
  config :clean_session, :validate => :boolean, :default => true

  # The topic that the plugin should subscribe to
  config :topic, :validate => :string, :required => true, :default => "#"

  # The topic qos that the plugin should subscribe with
  config :qos, :validate => :number, :default => 0

  public
  def register
    @logger.info("mqtt register")
    @host = Socket.gethostname
    @client = MQTT::Client.connect(
        :host => @broker_host,
        :port => @broker_port,
        :ssl => @ssl,
        :username => @username,
        :password => @password,
        :client_id => @client_id,
        :clean_session => @clean_session
    )
  end # def register

  def run(queue)
    @logger.info("mqtt run")
    while !stop? 
      @logger.info("mqtt loop")
      # we can abort the loop if stop? becomes true

      @logger.info("subscribe to #{@topic}")
      @client.subscribe(@topic => @qos)
      @client.get do |topic,message|
        @logger.info("got message #{topic} <= #{message}")
        @codec.decode(message) do |event|
            event.set('host', @host)
            event.set('topic', topic)

            decorate(event)
            @logger.info("Sending event #{event}")
            queue << event
        end
      end
    end # loop
  end # def run

  def stop
    @logger.info("mqtt stop")
    # nothing to do in this case so it is not necessary to define stop
    # examples of common "stop" tasks:
    #  * close sockets (unblocking blocking reads/accepts)
    #  * cleanup temporary files
    #  * terminate spawned threads
  end

end # class LogStash::Inputs::Mqtt
                                   
