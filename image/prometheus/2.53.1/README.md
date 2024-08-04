
# Prometheus Docker Setup

This repository provides a Docker image setup for Prometheus using Amazon Linux 2. The following instructions guide you through building the Docker image and running a Prometheus container.

## Prometheus Image Build

To build the Prometheus Docker image, follow these steps:

```sh
cd /opt
sudo git clone https://github.com/Eliyaser/my-docker-works.git
sudo chown -R $USER:$USER /opt/prometheus-docker-setup 
sudo docker image build -t my-prometheus-image:v2.53.1 -f docker/image/prometheus/2.46.0/amazon-linux-2.dockerfile docker/image/prometheus/2.53.1/context
 ```

## Run Container Command

To start the Prometheus container, use the following command:

```sh
sudo docker network create -d bridge --subnet=15.1.0.0/16  sloopstash-dev-prometheus
sudo docker container run -i -t --rm \
-v /opt/docker/workload/supervisor/conf/server.conf:/etc/supervisord.conf \
-v /opt/docker/workload/prometheus/2.46.0/conf/supervisor.ini:/opt/prometheus/system/supervisor.ini \
-v /opt/docker/workload/prometheus/2.46.0/conf/server.conf:/opt/prometheus/prometheus.yml \
-p 9090:9090 \
--entrypoint /usr/bin/supervisord \
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
#Docker image to use
From sloopstash/base:v1.1.1

#Download and extract Prometheus
WORKDIR /tmp
RUN set -x \
&& wget https://github.com/prometheus/prometheus/releases/download/v2.53.1/prometheus-2.53.1.linux-amd64.tar.gz --quiet \
&& tar -xvzf prometheus-2.53.1.linux-amd64.tar.gz > /dev/null

#Compile and install Prometheus
WORKDIR prometheus-2.53.1.linux-amd64
RUN set -x \
&& cp prometheus /usr/local/bin/ \
&& cp promtool /usr/local/bin/

# Create Prometheus directories.
RUN set -x \
&& mkdir /opt/prometheus \
&& mkdir /opt/prometheus/data \
&& mkdir /opt/prometheus/log \
&& mkdir /opt/prometheus/conf \
&& mkdir /opt/prometheus/script \
&& mkdir /opt/prometheus/system \
&& mkdir /opt/prometheus/console_libraries \
&& mkdir /opt/prometheus/consoles \
&& touch /opt/prometheus/system/server.pid \
&& touch /opt/prometheus/system/supervisor.ini \
&& ln -s /opt/prometheus/system/supervisor.ini /etc/supervisord.d/prometheus.ini \
&& cp -r consoles/* /opt/prometheus/consoles \
&& cp -r console_libraries/* /opt/prometheus/console_libraries \
&& cd ../ \
&& rm -rf prometheus-2.53.1.linux* \
&& history -c

# Set default work directory.
WORKDIR /opt/prometheus


 ```
