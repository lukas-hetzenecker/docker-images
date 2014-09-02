# jira Server
#
# VERSION               0.0.1

FROM luhe/base
MAINTAINER Lukas Hetzenecker

# Environment
ENV JIRA_VERSION 6.3.4
ENV JIRA_HOME /home/jira

# Add startup script
ADD jira.sh /start/jira

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

# XML Parser
RUN eatmydata -- apt-get install -yq xmlstarlet

# Expose web and agent ports
EXPOSE 8080

# Run
CMD ["/start/jira"]
