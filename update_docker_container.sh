#!/bin/bash

###############################################################################
# Script Name : deploy-mbn-filescan.sh
#
# Purpose:
#   Automated deployment and rebuild of the MBN FileScan Docker container.
#
# Description:
#   This script performs a clean redeployment of the FileScan service by:
#     1. Removing any existing local source directory
#     2. Cloning the latest version from GitHub
#     3. Rebuilding the Docker image
#     4. Restarting the container using Docker Compose
#     5. Verifying container status and system time
#
# Requirements:
#   - Docker Engine installed
#   - Docker Compose v2 installed
#   - Internet access to GitHub
#   - User permissions to run Docker commands
#
# Deployment Location:
#   /opt/docker_persist/mbn-filescan-local
###############################################################################

# Change to persistent Docker application directory
cd /opt/docker_persist || exit 1


###############################################################################
# Remove existing deployment directory (clean install)
#
# Ensures:
#   - No stale source files remain
#   - Git repository is freshly cloned
#   - Local modifications do not affect deployment
###############################################################################
if [ -d /opt/docker_persist/mbn-filescan-local ]; then
    echo "Removing existing mbn-filescan-local directory..."
    rm -rf /opt/docker_persist/mbn-filescan-local
fi


###############################################################################
# Clone latest application source from GitHub repository
#
# Pulls:
#   - Dockerfile
#   - docker-compose.yml
#   - NodeJS application
#   - Bootstrap scripts
###############################################################################
echo "Cloning latest repository from GitHub..."
git clone https://github.com/CSIR-FB/mbn-filescan-local


###############################################################################
# Enter project directory
###############################################################################
cd /opt/docker_persist/mbn-filescan-local || exit 1


###############################################################################
# Stop and remove existing containers (if running)
#
# Prevents:
#   - Port conflicts
#   - Old container reuse
#   - Image locking issues
###############################################################################
echo "Stopping existing containers..."
docker compose down


###############################################################################
# Build Docker image and start container
#
# --build forces rebuild using latest Dockerfile changes
#
# Actions performed:
#   - Builds mbn-filescan Docker image
#   - Applies timezone configuration
#   - Updates ClamAV installation
#   - Starts FileScan API service
###############################################################################
echo "Building and starting container..."
docker compose up -d --build


###############################################################################
# Display locally available Docker images
#
# Useful for:
#   - Verifying image build success
#   - Confirming image version/tag
###############################################################################
echo "Listing Docker images..."
docker images


###############################################################################
# Display running containers
#
# Confirms:
#   - Container is running
#   - Port mappings are correct
###############################################################################
echo "Listing running containers..."
docker ps


###############################################################################
# Verify container timezone and system clock
#
# Ensures container time matches expected UTC+2 configuration
###############################################################################
echo "Checking container date/time..."
docker exec -it mbn-filescan-local date


###############################################################################
# Display container logs
#
# Used to confirm:
#   - ClamAV database updates
#   - Service startup success
#   - API listener availability
###############################################################################
echo "Displaying container logs..."
docker logs mbn-filescan-local

