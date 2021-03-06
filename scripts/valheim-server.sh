#!/bin/bash

function log_error() {
  echo "ERROR - $1"
  exit 1
}

valheimInstallPath="${valheimInstallPath:-/home/steam/valheim-install}"

# Allow for us to run the server on any port, but default to 2456 (which is the expected port on client-side).
serverPort=${serverPort:-2456}

if [ -z "${serverDisplayName}" ] || [ -z "${serverWorldName}" ]; then
  log_error "Expected serverDisplayName, serverWorldName variable to be set, but not found."
fi

# Separate by serverWorldName so that we this script works with multiple servers.
awsSecretId="/valheim/${serverWorldName}/serverPassword"
serverPassword=$(aws --region eu-west-2 secretsmanager get-secret-value --secret-id "${awsSecretId}" | jq -r .SecretString)

if [ $? -ne 0 ]; then
  log_error "Failed to pull server password from AWS SecretsManager with secret-id '${awsSecretId}'"
fi

# Install the Valheim app
# Include +app_update so that if this command runs and game is already installed, it'll install any potential updates. This means we just have to restart the container for updates to be installed.
/home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir ${valheimInstallPath} +app_update 896660 validate +exit

pushd "$valheimInstallPath"

# Start the server
exec ${valheimInstallPath}/valheim_server.x86_64 -name "${serverDisplayName}" -port "$serverPort" -nographics -batchmode -world "${serverWorldName}" -password "${serverPassword}"
