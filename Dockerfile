# Use a base image
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y wget jq bc supervisor curl nano 
  
# Set environment variables
ENV SISPOP_URL="https://github.com/sispop-dev/sispop/releases/download/v10.0.3/sispop-10.0.3.tar.gz"
ENV STORAGE_URL="https://github.com/sispop-dev/sispop/releases/download/v10.0.1/storage-ubuntu-20.tar.gz"
ENV SISPOPNET_URL="https://github.com/sispop-dev/sispopnet/releases/download/v9.0.0/sispopnet-r.tar.gz"
# Create a directory for downloads
WORKDIR /tmp/downloads
# Download and unpack Sispop Daemon
RUN apt-get update && \
    apt-get install -y wget && \
    wget -O sispop.tar.gz $SISPOP_URL && \
    tar -xzvf sispop.tar.gz -C /usr/local/bin && \
    rm sispop.tar.gz
# Download and unpack Storage Server
RUN wget -O storage.tar.gz $STORAGE_URL && \
    tar -xzvf storage.tar.gz -C /usr/local/bin && \
    rm storage.tar.gz
# Download and unpack Sispopnet
RUN wget -O sispopnet.tar.gz $SISPOPNET_URL && \
    tar -xzvf sispopnet.tar.gz -C /usr/local/bin && \
    rm sispopnet.tar.gz

# Copy init scripts
COPY sispop_init.sh /sispop_init.sh
COPY storage_init.sh /storage_init.sh
COPY sispopnet_init.sh /sispopnet_init.sh

# Set privilages
RUN chmod 755 /sispop_init.sh /storage_init.sh /sispopnet_init.sh

# Supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["/usr/bin/supervisord"]
