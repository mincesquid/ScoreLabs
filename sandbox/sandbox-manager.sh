#!/bin/bash
# Sandbox Manager - Core sandbox creation and management

set -e

SANDBOX_DIR="/var/lib/scorelabs/sandbox"
CONFIG_DIR="/etc/scorelabs/sandbox"

create_container_sandbox() {
    local name=$1
    local sandbox_path="${SANDBOX_DIR}/${name}"
    
    echo "Creating container sandbox: $name"
    
    # Create directory structure
    mkdir -p "$sandbox_path"
    mkdir -p "$sandbox_path/root"
    
    # Bootstrap minimal Arch system
    if command -v pacstrap &> /dev/null; then
        sudo pacstrap -c "$sandbox_path/root" base
    else
        echo "Note: pacstrap not available, creating minimal structure"
        mkdir -p "$sandbox_path/root"/{bin,etc,usr,var,tmp}
    fi
    
    # Create configuration
    cat > "$sandbox_path/config.nspawn" << EOF
[Exec]
Boot=no
PrivateUsers=yes

[Network]
Private=yes
VirtualEthernet=yes

[Files]
PrivateUsersChown=yes
EOF
    
    echo "Container sandbox created: $name"
    echo "Path: $sandbox_path"
}

create_vm_sandbox() {
    local name=$1
    local disk_size=${2:-20G}
    local sandbox_path="${SANDBOX_DIR}/${name}"
    
    echo "Creating VM sandbox: $name"
    
    mkdir -p "$sandbox_path"
    
    # Create disk image
    qemu-img create -f qcow2 "$sandbox_path/disk.qcow2" "$disk_size"
    
    # Create configuration
    cat > "$sandbox_path/vm.conf" << EOF
name: $name
type: vm
resources:
  memory: 2048
  cpu: 2
  disk: $disk_size
network:
  mode: nat
snapshots:
  auto: false
EOF
    
    echo "VM sandbox created: $name"
    echo "Path: $sandbox_path"
}

start_container() {
    local name=$1
    local sandbox_path="${SANDBOX_DIR}/${name}"
    
    if [ ! -d "$sandbox_path" ]; then
        echo "Error: Sandbox '$name' not found"
        exit 1
    fi
    
    echo "Starting container: $name"
    sudo systemd-nspawn \
        --directory="$sandbox_path/root" \
        --settings="$sandbox_path/config.nspawn" \
        --machine="scorelabs-$name"
}

start_vm() {
    local name=$1
    local sandbox_path="${SANDBOX_DIR}/${name}"
    
    if [ ! -f "$sandbox_path/disk.qcow2" ]; then
        echo "Error: VM disk not found"
        exit 1
    fi
    
    echo "Starting VM: $name"
    qemu-system-x86_64 \
        -enable-kvm \
        -m 2048 \
        -smp 2 \
        -drive file="$sandbox_path/disk.qcow2,format=qcow2" \
        -net nic -net user \
        -monitor unix:$sandbox_path/monitor.sock,server,nowait \
        -daemonize \
        -pidfile "$sandbox_path/qemu.pid"
    
    echo "VM started. PID: $(cat $sandbox_path/qemu.pid)"
}

list_sandboxes() {
    echo "Available sandboxes:"
    echo "─────────────────────────────────────"
    
    if [ ! -d "$SANDBOX_DIR" ]; then
        echo "No sandboxes found"
        return
    fi
    
    for sandbox in "$SANDBOX_DIR"/*; do
        if [ -d "$sandbox" ]; then
            local name=$(basename "$sandbox")
            local type="unknown"
            
            if [ -f "$sandbox/config.nspawn" ]; then
                type="container"
            elif [ -f "$sandbox/vm.conf" ]; then
                type="vm"
            fi
            
            echo "$name ($type)"
        fi
    done
}

# Main execution
case "$1" in
    create)
        if [ "$2" = "--type" ] && [ "$3" = "vm" ]; then
            create_vm_sandbox "$4" "${5:-20G}"
        else
            create_container_sandbox "$2"
        fi
        ;;
    start)
        # Auto-detect type
        if [ -f "${SANDBOX_DIR}/$2/vm.conf" ]; then
            start_vm "$2"
        else
            start_container "$2"
        fi
        ;;
    list)
        list_sandboxes
        ;;
    *)
        echo "Usage: $0 {create|start|list} [options]"
        exit 1
        ;;
esac
