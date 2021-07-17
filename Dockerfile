# Use official Steamcmd image
FROM cm2network/steamcmd:latest

USER steam
WORKDIR /home/steam

ADD --chown=steam:steam scripts/valheim-server.sh valheim-server.sh

ENTRYPOINT ["./scripts/valheim-server.sh"]
