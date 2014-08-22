# based on hwuethrich/bamboo-server

# Bamboo Server
#
# VERSION               0.0.1

FROM luhe/supervisord
MAINTAINER H. Wüthrich "hw@5px.ch"

# Environment
ENV BAMBOO_VERSION 5.4
ENV BAMBOO_HOME /home/bamboo

# Add startup script and supervisor config
ADD bamboo-server.sh /start/bamboo-server
ADD supervisor.conf /etc/supervisor/conf.d/bamboo-server.conf
ADD bamboo.cfg.xml.new /etc/bamboo.cfg.xml.new

# Prepare repos for Oracle Java 7 and Docker
RUN eatmydata -- apt-get install -yq software-properties-common && add-apt-repository ppa:webupd8team/java -y
RUN eatmydata -- apt-get install -yq apt-transport-https
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
RUN apt-get update

# Install Oracle Java 7
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN eatmydata -- apt-get install -yq oracle-java7-installer

# PostgreSQL Client
RUN eatmydata -- apt-get install -yq postgresql-client

# VCS tools
RUN eatmydata -- apt-get install -yq git subversion

# Docker
RUN eatmydata -- apt-get install -yq lxc-docker

# Fig
RUN eatmydata -- apt-get install -yq python-pip
RUN pip install fig

# XML Parser
RUN eatmydata -- apt-get install -yq xmlstarlet

# Add startup script
ADD start /start

# Expose web and agent ports
EXPOSE 8085
EXPOSE 54663

# Run supervisord
CMD ["/start/prepare"]
