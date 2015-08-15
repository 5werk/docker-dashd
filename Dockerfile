# Dockerfile for Dashd
# https://www.dashpay.io/

FROM debian:jessie
MAINTAINER Chris <christoph@5werk.ch>

RUN /usr/sbin/useradd -m -u dash
RUN /usr/sbin/useradd -m -u 1234 -d /dash -s /bin/bash dash \
  && chown dash -R /dash

RUN apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

ENV DASH_VERSION 0.12.0.44
ENV DASH_FOLDER 0.12.0
ENV DASH_DOWNLOAD_URL https://www.dashpay.io/binaries/dash-$DASH_VERSION-linux64.tar.gz
ENV DASH_SHA256 05ade8fdd701d6216733646ceb2fc5a5b38838d3d24cb79ae9e78e2fe72d25cc
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
ENV HOME /dash
VOLUME ["/dash"]
EXPOSE 9999

# Default arguments, can be overriden
CMD ["dashd"]
