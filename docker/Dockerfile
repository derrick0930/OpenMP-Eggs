FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    wine wine64 wine32:i386 libwine libwine:i386 fonts-wine \
    ca-certificates curl unzip tzdata iproute2 procps tini \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -m -d /home/container -s /bin/bash container

USER container
WORKDIR /home/container

ENV USER=container \
    HOME=/home/container \
    WINEPREFIX=/home/container/.wine \
    WINEARCH=win32 \
    WINEDEBUG=-all \
    WINEDLLOVERRIDES="mscoree,mshtml="

COPY --chown=container:container entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/bin/bash", "/entrypoint.sh"]
