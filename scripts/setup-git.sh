#!/usr/bin/env bash
#
# Git Configuration Setup Script for ScoreLabs
# This script ensures proper git configuration for working with the repository
#

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "======================================"
echo "ScoreLabs Git Configuration Setup"
echo "======================================"
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    echo "Please run this script from within the ScoreLabs repository"
    exit 1
fi

# Get current fetch configuration
CURRENT_FETCH=$(git config --get remote.origin.fetch 2>/dev/null || echo "")
RECOMMENDED_FETCH="+refs/heads/*:refs/remotes/origin/*"

echo -e "${YELLOW}Checking git remote configuration...${NC}"
echo ""

if [ "$CURRENT_FETCH" = "$RECOMMENDED_FETCH" ]; then
    echo -e "${GREEN}✓ Git remote fetch configuration is already correct${NC}"
    echo "  Current: $CURRENT_FETCH"
else
    echo -e "${YELLOW}⚠ Git remote fetch configuration needs updating${NC}"
    echo "  Current:     $CURRENT_FETCH"
    echo "  Recommended: $RECOMMENDED_FETCH"
    echo ""
    echo "This will allow you to fetch and merge all branches from the remote,"
    echo "including the main branch and any OS assets branches."
    echo ""
    read -p "Update configuration? [Y/n] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Configuration not updated${NC}"
        exit 0
    fi
    
    # Update the fetch configuration
    git config remote.origin.fetch "$RECOMMENDED_FETCH"
    echo -e "${GREEN}✓ Configuration updated${NC}"
fi

echo ""
echo -e "${YELLOW}Fetching all branches from remote...${NC}"
git fetch origin

echo ""
echo -e "${GREEN}✓ Setup complete!${NC}"
echo ""

# Check if user has a local main branch
if ! git rev-parse --verify main > /dev/null 2>&1; then
    if git rev-parse --verify origin/main > /dev/null 2>&1; then
        echo -e "${YELLOW}Note: You don't have a local 'main' branch.${NC}"
        echo ""
        read -p "Create a local 'main' branch from origin/main? [Y/n] " -n 1 -r
        echo ""
        
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
            git checkout -b main origin/main
            echo -e "${GREEN}✓ Created local 'main' branch${NC}"
            echo ""
            # Only try to switch back if we were on a branch before
            if [ -n "$CURRENT_BRANCH" ] && [ "$CURRENT_BRANCH" != "main" ]; then
                git checkout "$CURRENT_BRANCH" 2>/dev/null || true
            fi
        fi
    fi
fi

echo "You can now see all available branches:"
echo "  git branch -a"
echo ""
echo "And merge from any branch:"
echo "  git merge origin/main"
echo "  git merge origin/<branch-name>"
echo ""