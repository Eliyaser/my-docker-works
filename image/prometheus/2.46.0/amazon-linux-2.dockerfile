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
  && mv prometheus.yml /opt/prometheus/
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

# Expose Prometheus port
EXPOSE 9090

# Set the entrypoint to supervisord
ENTRYPOINT ["/usr/bin/supervisord"]
