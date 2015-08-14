# Dockerfile for Dashd
# https://www.dashpay.io/

FROM debian:jessie
MAINTAINER Chris <christoph@5werk.ch>

RUN /usr/sbin/useradd -m -u 1234 -d /dash -s /bin/bash dash \
  && chown dash:dash -R /dash

RUN apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

ENV DASH_VERSION 0.12.0.44
ENV DASH_DOWNLOAD_URL https://www.dashpay.io/binaries/dash-$DASH_VERSION-linux.tar.gz
ENV DASH_SHA256 a6aefddd126c5271f52117c27901ece2c369a31d00c2abde3e23581716c489ac
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
