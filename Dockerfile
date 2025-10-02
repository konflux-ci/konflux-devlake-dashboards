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

FROM registry.access.redhat.com/ubi9/ubi:9.6-1758184894@sha256:dbc1e98d14a022542e45b5f22e0206d3f86b5bdf237b58ee7170c9ddd1b3a283

ENV SUMMARY="Grafana is an open source, feature rich metrics dashboard and graph editor" \
    DESCRIPTION="Grafana is an open source, feature rich metrics dashboard and graph editor for Graphite, Elasticsearch, OpenTSDB, Prometheus, InfluxDB and Performance Co-Pilot." \
    VERSION=11

LABEL name="rhel9/grafana" \
      summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      version="$VERSION" \
      usage="podman run -d --name grafana -p 3000:3000 -v grafana-data:/var/lib/grafana registry.redhat.io/rhel9/grafana" \
      maintainer="Grafana Maintainers <grafana-maint@redhat.com>" \
      help="cat /README.md" \
      com.redhat.component="grafana-container" \
      io.k8s.display-name="Grafana" \
      io.k8s.description="${DESCRIPTION}" \
      io.openshift.expose-services="3000:grafana" \
      io.openshift.tags="grafana,monitoring,dashboard"

ENV GF_INSTALL_PLUGINS=""

RUN useradd -u 1001 -g 0 -r -d /usr/share/grafana -s /sbin/nologin grafana && \
    dnf upgrade -y && \
    dnf install -y --setopt=tsflags=nodocs grafana grafana-pcp && \
    dnf clean all && \
    chgrp -R 0 /etc/grafana /var/lib/grafana /var/log/grafana && \
    chmod -R g=u /var/lib/grafana /var/log/grafana

COPY root /

VOLUME ["/var/lib/grafana"]
EXPOSE 3000

USER 1001
WORKDIR /usr/share/grafana
ENTRYPOINT ["/usr/bin/run-grafana"]
