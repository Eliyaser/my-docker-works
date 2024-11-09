
# Prometheus Docker Setup

This repository provides a Docker image setup for Prometheus using Amazon Linux 2. The following instructions guide you through building the Docker image and running a Prometheus container.

## Prometheus Image Build

To build the Prometheus Docker image, follow these steps:

```sh
cd /opt
sudo git clone https://github.com/Eliyaser/my-docker-works.git
sudo chown -R $USER:$USER /opt/my-docker-works
sudo docker image build -t my-prometheus-image:v2.46.0 -f my-docker-works/image/prometheus/2.46.0/amazon-linux-2.dockerfile my-docker-works/image/prometheus/2.46.0/context
 ```

## Run Container Command

To start the Prometheus container, use the following command:

```sh
sudo docker container run -i -t --rm \
-v /opt/my-docker-works/workload/supervisor/conf/server.conf:/etc/supervisord.conf \
-v /opt/my-docker-works/workload/prometheus/2.46.0/conf/supervisor.ini:/opt/prometheus/system/supervisor.ini \
-v /opt/my-docker-works/workload/prometheus/2.46.0/conf/server.conf:/opt/prometheus/prometheus.yml \
-p 9090:9090 \
--entrypoint /usr/local/bin/supervisord \
my-prometheus-image:v2.46.0 \
-c /etc/supervisord.conf
 ```
## Second Terminal

To access the running container and check the status of Prometheus, use the following commands:

```sh
sudo docker container exec -ti YOUR_Container_NAME /bin/bash
ps -ef
supervisorctl status
supervisorctl start prometheus
supervisorctl stop Prometheus
 ```

##Verify that Prometheus is running by opening your browser and navigating to:
http://192.168.101.5:9090


## Dockerfile

The Dockerfile sets up the necessary environment to run Prometheus:

```Dockerfile
# Docker image to use.
FROM sloopstash/base:v1.1.1

# Set the Prometheus version
ENV PROMETHEUS_VERSION=2.46.0

# Install system packages.
RUN yum install -y tcl

# Download and extract Prometheus.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz --quiet \
  && tar xvzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz > /dev/null

# Move Prometheus binaries to a directory in PATH.
WORKDIR prometheus-${PROMETHEUS_VERSION}.linux-amd64
RUN set -x \
  && mkdir /opt/prometheus \
  && mv prometheus /usr/local/bin/ \
  && mv promtool /usr/local/bin/ \
  && mv consoles /opt/prometheus/ \
  && mv console_libraries /opt/prometheus/ \
  && mv prometheus.yml /opt/prometheus/ \
  && mkdir /opt/prometheus/system \
  && touch /opt/prometheus/system/server.pid \
  && touch /opt/prometheus/system/supervisor.ini \
  && ln -s /opt/prometheus/system/supervisor.ini /etc/supervisord.d/prometheus.ini \
  && history -c

# Create a directory for Prometheus data
RUN mkdir -p /var/lib/prometheus

# Clean up
WORKDIR /
RUN rm -rf /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64*

# Set default work directory.
WORKDIR /opt/Prometheus

 ```
