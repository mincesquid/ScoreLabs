#!/bin/bash
# Customize airootfs script for ScoreLabs
# This script runs during the ISO build to customize the root filesystem

set -e

echo "Customizing ScoreLabs airootfs..."

# Run system configuration
if [ -f /root/system-config.sh ]; then
    bash /root/system-config.sh
fi

echo "Customization complete."