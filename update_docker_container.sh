#!/bin/bash

###############################################################################
# Script Name : deploy-mbn-filescan.sh
#
# Purpose:
#   Automated deployment and rebuild of the MBN FileScan Docker container.
#
# Safety Control:
#   Prevent execution from inside /opt/docker_persist to avoid deleting
#   the active working directory during deployment.
###############################################################################

DEPLOY_DIR="/opt/docker_persist"
APP_DIR="$DEPLOY_DIR/mbn-filescan-local"

###############################################################################
# SAFETY CHECK
# Prevent script execution inside /opt/docker_persist
###############################################################################

CURRENT_DIR="$(pwd)"

if [[ "$CURRENT_DIR" == "$DEPLOY_DIR"* ]]; then
    echo "ERROR: Script must NOT be executed from inside $DEPLOY_DIR"
    echo "Current directory: $CURRENT_DIR"
    echo "Please run this script from another location."
    exit 1
fi

echo "Execution directory check passed."


###############################################################################
# Change to deployment parent directory
###############################################################################
cd "$DEPLOY_DIR"


###############################################################################
# Remove existing deployment directory
###############################################################################
if [ -d "$APP_DIR" ]; then
    echo "Removing existing mbn-filescan-local directory..."
    rm -rf "$APP_DIR"
fi


###############################################################################
# Clone latest repository
###############################################################################
echo "Cloning latest repository from GitHub..."
git clone https://github.com/CSIR-FB/mbn-filescan-local


###############################################################################
# Enter project directory
###############################################################################
cd "$APP_DIR"


###############################################################################
# Stop existing containers
###############################################################################
echo "Stopping existing containers..."
docker compose down || true


###############################################################################
# Build and start container
###############################################################################
echo "Building and starting container..."
docker compose up -d --build


###############################################################################
# Verification Steps
###############################################################################
echo "Listing Docker images..."
docker images

echo "Listing running containers..."
docker ps

echo "Checking container date/time..."
docker exec -it mbn-filescan-local date

echo "Displaying container logs..."
docker logs mbn-filescan-local

