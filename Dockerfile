FROM ubuntu:22.04

# Install required dependencies
RUN apt-get update && apt-get install -y \
    lib32gcc-s1 \
    libatomic1 \
    libpulse-dev \
    libpulse0 \
    steamcmd \
    && rm -rf /var/lib/apt/lists/*

# Create steam user and directory
RUN useradd -m steam
WORKDIR /home/steam
USER steam

# Install SteamCMD and Valheim Dedicated Server
RUN steamcmd +login anonymous \
    +force_install_dir /home/steam/valheim \
    +app_update 896660 validate \
    +quit

# Copy server start script
COPY start_server.sh /home/steam/valheim/
RUN chmod +x /home/steam/valheim/start_server.sh

# Default environment variables
ENV PORT=2456 \
    SERVER_NAME="Valheim Server" \
    WORLD_NAME="fortheboyz" \
    SERVER_PASS="tybg" \
    SERVER_PUBLIC=1

# Expose necessary ports
EXPOSE ${PORT}/udp
EXPOSE $((PORT+1))/udp

# Start script
CMD ["/home/steam/valheim/start_server.sh"]
