# based on hwuethrich/supervisord

# Base image with supervisord
# http://supervisord.org/

FROM luhe/base
MAINTAINER Lukas Hetzenecker

# Install supervisor
RUN eatmydata apt-get -yq install supervisor && /etc/init.d/supervisor stop

# Configure supervisor
ADD supervisord.conf /etc/supervisor/supervisord.conf

# Add startup script
ADD start /start

# Run supervisord
CMD ["/start/supervisord"]
