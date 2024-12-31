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

# Copy server start script first (while still root)
COPY start_server.sh /home/steam/valheim/
RUN chown steam:steam /home/steam/valheim/start_server.sh && \
    chmod +x /home/steam/valheim/start_server.sh

# Switch to steam user
WORKDIR /home/steam
USER steam

# Install SteamCMD and Valheim Dedicated Server
RUN steamcmd +login anonymous \
    +force_install_dir /home/steam/valheim \
    +app_update 896660 validate \
    +quit

# Default environment variables
ENV PORT=2456 \
    SERVER_NAME="Railway Valheim Server" \
    WORLD_NAME="Railway" \
    SERVER_PASS="changeme" \
    SERVER_PUBLIC=1

# Expose necessary ports (2456 and 2457 for Valheim)
EXPOSE 2456/udp
EXPOSE 2457/udp

# Start script
CMD ["/home/steam/valheim/start_server.sh"] 
