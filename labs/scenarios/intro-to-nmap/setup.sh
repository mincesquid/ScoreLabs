#!/bin/bash
# Lab setup script for Introduction to Nmap

set -e

LAB_NAME="intro-to-nmap"
NETWORK="10.0.100.0/24"

echo "Setting up lab: $LAB_NAME"

# Create docker-compose environment
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web-server:
    image: nginx:latest
    container_name: nmap-lab-web
    networks:
      lab-network:
        ipv4_address: 10.0.100.10
    ports:
      - "10080:80"
      - "10443:443"
    volumes:
      - ./web-content:/usr/share/nginx/html:ro

  database:
    image: mongo:latest
    container_name: nmap-lab-db
    networks:
      lab-network:
        ipv4_address: 10.0.100.11
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: password
    ports:
      - "27017:27017"
      - "12345:12345"  # Hidden service

  file-server:
    image: ubuntu:18.04
    container_name: nmap-lab-files
    networks:
      lab-network:
        ipv4_address: 10.0.100.12
    command: >
      sh -c "apt-get update &&
             apt-get install -y samba openssh-server vsftpd &&
             service smbd start &&
             service ssh start &&
             service vsftpd start &&
             tail -f /dev/null"

  router:
    image: alpine:latest
    container_name: nmap-lab-router
    networks:
      lab-network:
        ipv4_address: 10.0.100.1
    command: >
      sh -c "apk add --no-cache lighttpd &&
             lighttpd -D -f /etc/lighttpd/lighttpd.conf"

networks:
  lab-network:
    driver: bridge
    ipam:
      config:
        - subnet: 10.0.100.0/24
          gateway: 10.0.100.254
EOF

# Create web content with flag
mkdir -p web-content
cat > web-content/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>ScoreLabs - Nmap Lab</title>
</head>
<body>
    <h1>Welcome to the Nmap Lab</h1>
    <p>You've successfully discovered the web server!</p>
    <p>Server: nginx/1.18.0</p>
    <!-- Flag hidden in comments: part of Task 2 -->
</body>
</html>
EOF

# Start the environment
echo "Starting lab environment..."
docker-compose up -d

echo ""
echo "Lab environment ready!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Network: $NETWORK"
echo "Gateway: 10.0.100.254"
echo ""
echo "Targets:"
echo "  - Web Server:     10.0.100.10"
echo "  - Database:       10.0.100.11"
echo "  - File Server:    10.0.100.12"
echo "  - Router:         10.0.100.1"
echo ""
echo "Access from host (example):"
echo "  - Web: http://localhost:10080"
echo "  - MongoDB: localhost:27017"
echo ""
echo "Begin scanning with: nmap -sn 10.0.100.0/24"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
