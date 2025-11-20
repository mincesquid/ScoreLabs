#!/usr/bin/env bash
# masscan-scan.sh - Helper to run masscan quickly & run nmap on discovered ports
# Usage: masscan-scan.sh TARGET [options]
# -r, --rate RATE      packets per second for masscan (default 1000)
# -p, --ports PORTS    port range for masscan (default 1-65535)
# -o, --out OUTFILE    output file base name (default masscan)
# -h, --help           show help

set -euo pipefail

PROG=$(basename "$0")
RATE=1000
PORTS="1-65535"
OUT=masscan
TARGET=""

show_help(){
    cat <<EOF
$PROG - run masscan and then nmap on discovered ports

Usage: $PROG TARGET [options]

Options:
  -r, --rate RATE      masscan packets per second (default: $RATE)
  -p, --ports PORTS    masscan port range (default: $PORTS)
  -o, --out OUT        output prefix (default: $OUT)
  -n, --nmap-opts OPTS extra options passed to nmap
  -h, --help           print this help and exit

Important: Only run masscan against targets you have permission to scan.
EOF
}

# parse args
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

ARGS=()
NMAP_OPTS=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--rate)
      RATE="$2"; shift 2;;
    -p|--ports)
      PORTS="$2"; shift 2;;
    -o|--out)
      OUT="$2"; shift 2;;
    -n|--nmap-opts)
      NMAP_OPTS="$2"; shift 2;;
    -h|--help)
      show_help; exit 0;;
    --) shift; break;;
    -* ) echo "Unknown option: $1" >&2; show_help; exit 1;;
    *) TARGET="$1"; shift;;
  esac
done

if [ -z "$TARGET" ]; then
  echo "ERROR: target is required" >&2
  show_help
  exit 1
fi

# check dependencies
if ! command -v masscan >/dev/null 2>&1; then
  echo "ERROR: masscan is not installed. Install with 'brew install masscan' (macOS) or 'apt install masscan' (linux)" >&2
  exit 2
fi
if ! command -v nmap >/dev/null 2>&1; then
  echo "ERROR: nmap is not installed. Install nmap first." >&2
  exit 2
fi

OUT_GNMAP="${OUT}.gnmap"
OUT_NMAP="${OUT}.nmap"

echo "Running masscan on $TARGET (ports=$PORTS rate=$RATE) — ensure you are authorized to scan this host" >&2

# masscan is noisy; it requires root to send raw traffic
sudo masscan -p$PORTS --rate $RATE $TARGET -oG "$OUT_GNMAP"

# Parse gnmap: lines with Ports: portnum/open/tcp
PORTS_FOUND=$(awk '/Ports: /{gsub(/ /,"",$0); if(/open/){for(i=1;i<=NF;i++){if($i ~ /Ports:/){for (j=i+1;j<=NF;j++){split($j,a,","); for(k in a){split(a[k],p,\"/\"); if(p[2]=="open") {printf "%s,",p[1]}}}}}}' "$OUT_GNMAP" | sed 's/,$//')

# fallback: if no ports found in the above gnmap parse, try to extract with grep
if [ -z "$PORTS_FOUND" ]; then
  PORTS_FOUND=$(grep "Ports: " "$OUT_GNMAP" | sed -n 's/^.*Ports: \(.*\)$/\1/p' | tr ',' '\n' | awk -F'/' '$2=="open"{print $1}' | paste -sd, -)
fi

if [ -z "$PORTS_FOUND" ]; then
  echo "No open ports found by masscan. Exiting." >&2
  exit 0
fi

echo "Masscan found open ports: $PORTS_FOUND" >&2

# Run nmap service detection on discovered ports
# Use --version-light for faster checks and conservative scan
NMAP_CMD=(nmap -sV --version-light -Pn -T4 -p "$PORTS_FOUND" $TARGET)
# If NMAP_OPTS provided, append
if [ -n "$NMAP_OPTS" ]; then
  NMAP_CMD+=( $NMAP_OPTS )
fi

echo "Running nmap on discovered ports: ${NMAP_CMD[*]}" >&2
"${NMAP_CMD[@]}" -oN "$OUT_NMAP"

# Print summary
echo "Results written to $OUT_GNMAP and $OUT_NMAP" >&2
exit 0
