#!/bin/bash
# ScoreLabs system configuration script
# Applies system-wide security and performance settings

set -e

echo "Applying ScoreLabs system configuration..."

# Kernel parameters for security and performance
cat > /etc/sysctl.d/99-scorelabs.conf << 'EOF'
# Network security
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Performance tuning
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5

# Security
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.yama.ptrace_scope = 1
EOF

# Firewall rules (nftables)
cat > /etc/nftables.conf << 'EOF'
#!/usr/bin/nft -f
# ScoreLabs default firewall rules

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        
        # Accept loopback
        iif lo accept
        
        # Accept established/related
        ct state established,related accept
        
        # Accept SSH (uncomment if needed)
        # tcp dport 22 accept
        
        # Drop invalid
        ct state invalid drop
    }
    
    chain forward {
        type filter hook forward priority 0; policy drop;
    }
    
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
EOF

echo "Configuration applied successfully!"
echo ""
echo "Note: These settings will be applied on the live system."
echo "To apply now: sudo sysctl --system"

# Run KDE desktop setup if scripts exist
if [ -f /root/security-kde-setup.sh ]; then
    echo "Running KDE security setup..."
    bash /root/security-kde-setup.sh
fi

if [ -f /root/advanced-kde-config.sh ]; then
    echo "Running advanced KDE configuration..."
    bash /root/advanced-kde-config.sh
fi
