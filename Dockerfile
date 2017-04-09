#!./docker-build-wrapper.sh -t unixbigot/logstash-mqtt
#
# Run this images with 
#
# docker run --rm -it -v $HOME/logstash/conf.d:/usr/share/logstash/pipeline -v $PWD:/src --name logstash unixbigot/logstash-mqtt
#
# 
FROM docker.elastic.co/logstash/logstash:5.3.0
RUN /usr/share/logstash/bin/logstash-plugin install logstash-codec-protobuf
ADD . /logstash-input-mqtt
WORKDIR /logstash-input-mqtt
ENV PATH="/usr/share/logstash/vendor/jruby/bin:${PATH}"
RUN /usr/share/logstash/bin/logstash-plugin install ./logstash-input-mqtt-0.1.0.gem
