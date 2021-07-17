# Use official Steamcmd image
FROM cm2network/steamcmd:latest

USER steam
WORKDIR /home/steam

ADD --chown=steam:steam scripts/valheim-server.sh valheim-server.sh

# Create some expected directories as they need to be owned by `steam` user and if we mount volume in without a previous existing directory, it'll end up being owned by root
# If these change, then there are follow-on changes necessary in compose-file volumes.
RUN mkdir -p /home/steam/valheim-install /home/steam/.config/unity3d/IronGate/Valheim/

ENTRYPOINT ["./scripts/valheim-server.sh"]
