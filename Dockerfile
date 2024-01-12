# Use a base image
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y wget supervisor curl nano
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
    tar -xzvf sispop.tar.gz -C /usr/local/bin --strip-components=1 && \
    rm sispop.tar.gz
# Download and unpack Storage Server
RUN wget -O storage.tar.gz $STORAGE_URL && \
    tar -xzvf storage.tar.gz -C /usr/local/bin --strip-components=1 && \
    rm storage.tar.gz
# Download and unpack Sispopnet
RUN wget -O sispopnet.tar.gz $SISPOPNET_URL && \
    tar -xzvf sispopnet.tar.gz -C /usr/local/bin --strip-components=1 && \
    rm sispopnet.tar.gz
# Copy init scripts
COPY sispop_init.sh /sispop_init.sh
COPY storage_init.sh /storage_init.sh
COPY sispopnet_init.sh /sispopnet_init.sh
COPY sispopnet.ini /sispopnet.ini
COPY health.sh /health.sh
# Set privilages
RUN chmod 755 /sispop_init.sh /storage_init.sh /sispopnet_init.sh /sispopnet.ini /health.sh
# Supervisord
RUN mkdir -p /var/log/supervisor
WORKDIR /logs
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
HEALTHCHECK --start-period=10m --interval=5m --retries=5 --timeout=40s CMD /health.sh
ENTRYPOINT ["/usr/bin/supervisord"]
