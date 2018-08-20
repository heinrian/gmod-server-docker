FROM debian:wheezy

MAINTAINER Suchipi Izumi "me@suchipi.com"

# ------------
# Prepare Gmod
# ------------

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install lib32gcc1 wget ca-certificates
RUN mkdir /steamcmd
WORKDIR /steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz
RUN mkdir /gmod-base
#RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod-base +app_update 4020 validate +quit
RUN dpkg --add-architecture i386 &&  apt-get update && apt-get install -y libc6:i386
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod-base +app_update 4020 validate +quit


# ----------------
# Annoying lib fix
# ----------------

RUN mkdir /gmod-libs
WORKDIR /gmod-libs
RUN wget http://launchpadlibrarian.net/195509222/libc6_2.15-0ubuntu10.10_i386.deb
RUN dpkg -x libc6_2.15-0ubuntu10.10_i386.deb .
RUN cp lib/i386-linux-gnu/* /gmod-base/bin/
WORKDIR /
RUN rm -rf /gmod-libs
RUN cp /steamcmd/linux32/libstdc++.so.6 /gmod-base/bin/

RUN mkdir -p /root/.steam
RUN mkdir -p /root/.steam/sdk32/
#RUN echo "wow"
#RUN ls -al /gmod-base/bin/
RUN cp /gmod-base/bin/libsteam_api.so /root/.steam/sdk32

# ----------------------
# Setup Volume and Union
# ----------------------

RUN mkdir /gmod-volume
VOLUME /gmod-volume
RUN mkdir /gmod-union
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install unionfs-fuse lib32tinfo5

# ---------------
# Setup Container
# ---------------

ADD start-server.sh /start-server.sh
EXPOSE 27015
EXPOSE 27015/udp
EXPOSE 27005
EXPOSE 27005/udp



ENV PORT="27015"
ENV MAXPLAYERS="16"
ENV G_HOSTNAME="Garry's Mod"
ENV GAMEMODE="terrortown"
ENV MAP="ttt_rooftops_2016_v1"
ENV WORKSHOP="1288317909"

CMD ["/bin/sh", "start-server.sh"]
