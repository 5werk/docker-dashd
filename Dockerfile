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

ENV DASH_VERSION 0.12.0.48
ENV DASH_FOLDER 0.12.0
ENV DASH_DOWNLOAD_URL https://www.dashpay.io/binaries/dash-$DASH_VERSION-linux64.tar.gz
ENV DASH_SHA256 43cc5b0b3cdc1cfdc72f4924bd4f6437fe28e062e62111d8752d9a78c32922f6
RUN cd /tmp \
  && curl -sSL "$DASH_DOWNLOAD_URL" -o dash.tgz \
  && echo "$DASH_SHA256 *dash.tgz" | /usr/bin/sha256sum -c - \
  && tar xzf dash.tgz --no-anchored dashd dash-cli --transform='s/.*\///' \
  && mv dashd dash-cli /usr/bin/ \
  && rm -rf dash* \
  && echo "#""!/bin/bash\n/usr/bin/dashd -datadir=/dash \"\$@\"" > /usr/local/bin/dashd \
  && echo "#""!/bin/bash\n/usr/bin/dash-cli -datadir=/dash \"\$@\"" > /usr/local/bin/dash-cli \
  && chmod a+x /usr/local/bin/dashd /usr/local/bin/dash-cli /usr/bin/dashd /usr/bin/dash-cli

USER dash
VOLUME ["/dash"]
EXPOSE 9999

# Default arguments, can be overriden
CMD ["dashd"]
