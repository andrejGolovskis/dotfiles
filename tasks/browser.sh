#!/bin/bash

set -e

# Extract the download URL from the Vivaldi download page
DOWNLOADURL="https://vivaldi.com/download/vivaldi-stable_amd64.deb"
INSTALLER=$(mktemp --suffix=.vivaldi.deb)

echo "Downloading Vivaldi from $DOWNLOADURL"

# Download the package to the temporary file
curl -L "$DOWNLOADURL" -o "$INSTALLER"

# Install the package
sudo dpkg -i "$INSTALLER"

# Remove the temporary file
rm "$INSTALLER"

echo "Vivaldi installation complete."