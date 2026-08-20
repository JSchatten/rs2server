FROM cm2network/steamcmd:steam-bookworm

USER root

COPY ./rs2server.sh /
RUN chmod +x /rs2server.sh

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get -y install --no-install-recommends --reinstall \
        ca-certificates locales procps wget gnupg2 software-properties-common libcurl4 \
    && touch /etc/locale.gen \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && mkdir -p /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && echo "deb [signed-by=/etc/apt/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/debian bookworm main" > /etc/apt/sources.list.d/winehq.list \
    && apt-get update \
    && apt-get -y install --install-recommends winehq-stable xvfb sudo \
    && echo "steam ALL=(root) NOPASSWD: ALL" >> /etc/sudoers \
    && rm -rf /var/lib/apt/lists/* /etc/apt/keyrings/winehq-archive.key

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

USER steam
ENV HOME=/home/steam
ENV WINEPREFIX=$HOME/wine
ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV DISPLAY=:1
ENV XDG_RUNTIME_DIR=/run/user/1000
WORKDIR /home/steam

COPY rs2server.txt /home/steam/rs2server.txt

ENTRYPOINT ["/rs2server.sh"]
CMD ["/bin/bash"]
