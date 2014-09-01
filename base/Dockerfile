# based on hwuethrich/base

# Base
#
# VERSION               0.0.1

FROM ubuntu:14.04
MAINTAINER H. Wüthrich "hw@5px.ch"

# Tell dpkg not to ask questions
ENV DEBIAN_FRONTEND noninteractive

# This forces dpkg not to call sync() after package extraction and speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup

# We don't need an apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

# Make sure the package repository is up to date
RUN apt-get update && apt-get -qy install eatmydata language-pack-en # 11/09/2013

# Fix locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

ADD common.bash /opt/scripts/common.bash

# Add init scripts
ADD init /init
