# Set the base image
FROM ubuntu:20.04

# Set environment variables
ENV USER root

# Set working directory
WORKDIR /root/steam

# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

# Update the repository and install SteamCMD
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends ca-certificates locales steamcmd \
 && rm -rf /var/lib/apt/lists/*

# Add unicode support
RUN locale-gen en_US.UTF-8
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'

# Create symlink for executable
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Update SteamCMD and verify latest version
RUN steamcmd +quit

WORKDIR /root/valheim

ADD entrypoint.sh .
RUN chmod +x entrypoint.sh

ADD install_valheim.sh .
RUN chmod +x install_valheim.sh && ./install_valheim.sh

RUN export LD_LIBRARY_PATH=/root/valheim/linux64/:/root/.steam/steamcmd/linux64/:$LD_LIBRARY_PATH \
 && export SteamAppID=892970

# Set default command
ENTRYPOINT ["./entrypoint.sh"]