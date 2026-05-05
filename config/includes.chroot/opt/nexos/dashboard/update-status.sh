#!/bin/bash
# ============================================================
#  NexOS — Status Update Script for Dashboard
#  Collects system status and writes it to status.json
# ============================================================

OUT_FILE="/opt/nexos/dashboard/status.json"

# Helper function to check service status
check_service() {
    if systemctl is-active --quiet "$1"; then
        echo "\"active\""
    else
        echo "\"inactive\""
    fi
}

check_firewall() {
    if command -v ufw &> /dev/null; then
        if ufw status | grep -q "Status: active"; then
            echo "\"active\""
            return
        fi
    fi
    echo "\"inactive\""
}

STATUS_TOR=$(check_service tor)
STATUS_PG=$(check_service postgresql)
STATUS_MDB=$(check_service mariadb)
STATUS_FW=$(check_firewall)

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Ensure directory exists
mkdir -p /opt/nexos/dashboard

# Generate JSON
cat <<EOF > "$OUT_FILE"
{
  "timestamp": "$TIMESTAMP",
  "services": {
    "tor": $STATUS_TOR,
    "postgresql": $STATUS_PG,
    "mariadb": $STATUS_MDB,
    "firewall": $STATUS_FW
  }
}
EOF

# Ensure file is readable by any web browser running locally
chmod 644 "$OUT_FILE"
