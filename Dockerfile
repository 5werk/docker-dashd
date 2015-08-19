# Dockerfile for Dashd
# https://www.dashpay.io/

FROM debian:jessie
MAINTAINER Chris <christoph@5werk.ch>
LABEL description="dockerized dashd for running masternodes"

RUN apt-get update \
  && apt-get install -y curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME /dash
RUN /usr/sbin/useradd -s /bin/bash -m -d /dash dash \
  && chown dash:dash -R /dash

ENV DASH_VERSION 0.12.0.46
ENV DASH_FOLDER 0.12.0
ENV DASH_DOWNLOAD_URL https://www.dashpay.io/binaries/dash-$DASH_VERSION-linux64.tar.gz
ENV DASH_SHA256 24c22be6ff7131e915617d7432e8345dcf12a0dd8f8103d075fcd060b9ca7680
RUN cd /tmp \
  && curl -sSL "$DASH_DOWNLOAD_URL" -o dash.tgz \
  && echo "$DASH_SHA256 *dash.tgz" | /usr/bin/sha256sum -c - \
  && tar xzf dash.tgz dash-$DASH_FOLDER/bin/dashd \
  && tar xzf dash.tgz dash-$DASH_FOLDER/bin/dash-cli \
  && cp dash-$DASH_FOLDER/bin/dashd /usr/bin/dashd \
  && cp dash-$DASH_FOLDER/bin/dash-cli /usr/bin/dash-cli \
  && rm -rf dash* \
  && echo "#""!/bin/bash\n/usr/bin/dashd -datadir=/dash \"\$@\"" > /usr/local/bin/dashd \
  && chmod a+x /usr/local/bin/dashd \
  && chmod a+x /usr/bin/dashd \
  && chmod a+x /usr/bin/dash-cli

USER dash
VOLUME ["/dash"]
EXPOSE 9999

# Default arguments, can be overriden
CMD ["dashd"]
