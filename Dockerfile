FROM lanopsdev/manager-base:v1.0-rc2
MAINTAINER Thornton Phillis (Th0rn0@lanops.co.uk)

# ENV - App Defaults

ENV ENABLE_HTTPS false
ENV LOG_FILES false
ENV ANALYTICS_PROVIDER GoogleAnalytics
ENV DB_MIGRATE false

# Files

COPY resources/docker/root /
WORKDIR $NGINX_DOCUMENT_ROOT
COPY src/ $NGINX_DOCUMENT_ROOT

# Default Command

ENTRYPOINT ["/run/docker-entrypoint.sh"]
