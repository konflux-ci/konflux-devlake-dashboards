# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#Apache DevLake is an effort undergoing incubation at The Apache Software
#Foundation (ASF), sponsored by the Apache Incubator PMC.
#
#Incubation is required of all newly accepted projects until a further review
#indicates that the infrastructure, communications, and decision making process
#have stabilized in a manner consistent with other successful ASF projects.
#
#While incubation status is not necessarily a reflection of the completeness or stability of the code,
#it does indicate that the project has yet to be fully endorsed by the ASF.

FROM registry.redhat.io/ubi9/ubi:9.4

# Install Grafana
RUN dnf update -y && \
    dnf install -y wget && \
    wget https://dl.grafana.com/oss/release/grafana-11.6.2-1.x86_64.rpm && \
    dnf install -y grafana-11.6.2-1.x86_64.rpm && \
    rm grafana-11.6.2-1.x86_64.rpm && \
    dnf clean all

# Create necessary directories
RUN mkdir -p /etc/grafana/provisioning/dashboards && \
    mkdir -p /etc/grafana/provisioning/datasources && \
    mkdir -p /etc/grafana/dashboards

COPY ./provisioning/dashboards /etc/grafana/provisioning/dashboards
COPY ./provisioning/datasources /etc/grafana/provisioning/datasources
COPY ./dashboards /etc/grafana/dashboards
COPY ./img/grafana_icon.svg /usr/share/grafana/public/img/grafana_icon.svg
COPY ./img /usr/share/grafana/public/img/lake
ENV GF_USERS_ALLOW_SIGN_UP=false
ENV GF_SERVER_SERVE_FROM_SUB_PATH=true
ENV GF_DASHBOARDS_JSON_ENABLED=true
ENV GF_LIVE_ALLOWED_ORIGINS='*'
ENV GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/etc/grafana/dashboards/Homepage.json

# Install Grafana plugins
RUN grafana-cli plugins install grafana-piechart-panel

# Expose Grafana port
EXPOSE 3000

# Start Grafana
CMD ["grafana-server", "--config=/etc/grafana/grafana.ini", "--homepath=/usr/share/grafana", "cfg:default.paths.logs=/var/log/grafana", "cfg:default.paths.data=/var/lib/grafana", "cfg:default.paths.plugins=/var/lib/grafana/plugins"]
