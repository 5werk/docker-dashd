# Dockerfile for Dashd
# https://www.dashpay.io/

FROM debian:jessie
MAINTAINER Chris <chris@5werk.ch>

RUN /usr/sbin/useradd -m -u 1234 -d /dash -s /bin/bash dash \
  && chown dash:dash -R /dash

RUN apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

ENV DASH_VERSION 0.11.2.22
ENV DASH_DOWNLOAD_URL https://www.dashpay.io/binaries/dash-$DASH_VERSION-linux.tar.gz
ENV DASH_SHA256 1d5ca8b764ee2445fed9e551f3f8f803dc9bdd03a6b561ee4393b40b7c1f0053
RUN cd /tmp \
  && curl -sSL "$DASH_DOWNLOAD_URL" -o dash.tgz \
  && echo "$DASH_SHA256 *dash.tgz" | /usr/bin/sha256sum -c - \
  && tar xzf dash.tgz dash-$DASH_VERSION-linux/bin/64/dashd \
  && cp dash-$DASH_VERSION-linux/bin/64/dashd /usr/bin/dashd \
  && rm -rf dash* \
  && echo "#""!/bin/bash\n/usr/bin/dashd -datadir=/dash \"\$@\"" > /usr/local/bin/dashd \
  && chmod a+x /usr/local/bin/dashd \
  && chmod a+x /usr/bin/dashd

USER dash
ENV HOME /dash
VOLUME ["/dash"]
EXPOSE 9999

# Default arguments, can be overriden
CMD ["dashd"]
