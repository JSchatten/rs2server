FROM cm2network/steamcmd:steam-bookworm

USER root

COPY ./rs2server.sh /
RUN chmod +x /rs2server.sh

RUN apt-get update
RUN apt-get -y install --no-install-recommends wget locales procps
RUN touch /etc/locale.gen
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen
# RUN rm -rf /var/lib/apt/lists/*



RUN dpkg --add-architecture i386
RUN apt-get update

RUN apt-get -y install --reinstall ca-certificates
RUN apt-get -y install gnupg2 software-properties-common libcurl4

RUN mkdir -p /etc/apt/keyrings
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN echo "deb [signed-by=/etc/apt/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/debian bookworm main" | tee /etc/apt/sources.list.d/winehq.list
RUN apt-get update
RUN apt-get -y install --install-recommends winehq-stable xvfb


ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get install -y sudo
# RUN useradd -m steam
RUN echo "steam ALL=(root) NOPASSWD: ALL" >> /etc/sudoers

# RUN apt-get -y --purge remove software-properties-common gnupg2
# RUN apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

USER steam
ENV HOME=/home/steam
ENV WINEPREFIX=$HOME/wine
ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV DISPLAY=:0:0
ENV XDG_RUNTIME_DIR=/run/user/1000
WORKDIR /home/steam

COPY rs2server.txt /home/steam/rs2server.txt

ENTRYPOINT ["/rs2server.sh"]
CMD ["/bin/bash"]
# CMD sleep 15000
