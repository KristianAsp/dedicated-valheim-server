#!/bin/bash

function log_error() {
  echo "ERROR - $1"
  exit 1
}

valheimInstallPath="${valheimInstallPath:-/home/steam/valheim-install}"

# Allow for us to run the server on any port, but default to 2456 (which is the expected port on client-side).
serverPort=${serverPort:-2456}

if [ -z "${serverDisplayName}" ] || [ -z "${serverWorldName}" ] || [ -z "${serverPassword}" ]; then
  log_error "Expected serverDisplayName, serverWorldName and serverPassword environment variable to be set, but not found."
fi

# Install the Valheim app
# Include +app_update so that if this command runs and game is already installed, it'll install any potential updates. This means we just have to restart the container for updates to be installed.
/home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir ${valheimInstallPath} +app_update 896660 validate +exit

pushd "$valheimInstallPath"

# Start the server
exec valheim_server.x86_64 -name "${serverDisplayName}" -port "$serverPort" -nographics -batchmode -world "${serverWorldName}" -password "${serverPassword}"
