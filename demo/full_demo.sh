#!/usr/bin/env bash
# Full AI Burst Cloud demo — simulates install, startup, routing, and health check
# Used by vhs tape for recording

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

slow_type() {
    local text="$1" delay="${2:-0.03}"
    for ((i=0; i<${#text}; i++)); do
        printf '%s' "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

prompt() {
    printf "${GREEN}>${RESET} "
}

# ── Install ───────────────────────────────────
echo ""
prompt
slow_type "# Install AI Burst Cloud" 0.04
sleep 0.5

prompt
slow_type "pip install git+https://github.com/aiburstcloud/aiburstcloud.git" 0.02
sleep 0.3
echo "Collecting aiburstcloud"
sleep 0.2
echo "  Downloading aiburstcloud-0.1.0.tar.gz (21 kB)"
sleep 0.2
echo "Installing collected packages: aiburstcloud"
sleep 0.2
echo -e "${GREEN}Successfully installed aiburstcloud-0.1.0${RESET}"
sleep 1

# ── Start ─────────────────────────────────────
echo ""
prompt
slow_type "# Start the router" 0.04
sleep 0.3

prompt
slow_type "aiburstcloud" 0.04
sleep 0.5
echo ""
echo -e "${GREEN}INFO${RESET}:     AI Burst Cloud v0.1.0"
sleep 0.2
echo -e "${GREEN}INFO${RESET}:     Burst mode: ${CYAN}edge_burst${RESET} (local primary, cloud overflow)"
sleep 0.2
echo -e "${GREEN}INFO${RESET}:     Local backend: http://localhost:11434 ${GREEN}healthy${RESET}"
sleep 0.2
echo -e "${GREEN}INFO${RESET}:     Cloud backend: https://api.runpod.ai/v2/*** ${GREEN}healthy${RESET}"
sleep 0.2
echo -e "${GREEN}INFO${RESET}:     Daily cloud budget: \$5.00"
sleep 0.2
echo -e "${GREEN}INFO${RESET}:     Uvicorn running on ${BOLD}http://0.0.0.0:8000${RESET}"
sleep 1.5

# ── Routing ───────────────────────────────────
echo ""
prompt
slow_type "# Send requests — watch them route automatically" 0.03
sleep 0.5
echo ""

route() {
    local ts backend color reason budget sensitivity latency
    ts=$(date '+%H:%M:%S')
    backend=$1; reason=$2; budget=$3; sensitivity=$4; latency=$5
    color=$GREEN
    [ "$backend" = "cloud" ] && color=$YELLOW
    echo -e "${DIM}${ts}${RESET}  Route: ${color}${backend}${RESET}  | reason=${reason} | budget=\$${budget} | sensitivity=${sensitivity} | ${latency}ms"
}

route "local"  "local_available" "5.00" "public"    "142"
sleep 0.5
route "local"  "local_available" "5.00" "public"    "138"
sleep 0.5
route "local"  "local_available" "5.00" "public"    "151"
sleep 0.4
route "local"  "local_available" "5.00" "public"    "289"
sleep 0.3
route "local"  "local_available" "5.00" "public"    "445"
sleep 0.3
echo ""
echo -e "${YELLOW}WARN${RESET}:     Local queue depth 5/5 — bursting to cloud"
sleep 0.5
route "cloud"  "local_overloaded_burst_to_cloud" "4.98" "public"    "318"
sleep 0.4
route "cloud"  "local_overloaded_burst_to_cloud" "4.96" "public"    "295"
sleep 0.4
route "local"  "sensitive_data_force_local"       "4.96" "sensitive" "156"
sleep 0.4
route "cloud"  "local_overloaded_burst_to_cloud" "4.94" "public"    "301"
sleep 1

echo ""
echo -e "${DIM}# ^ Sensitive request forced to local — even during burst${RESET}"
sleep 2

# ── Health Check ──────────────────────────────
echo ""
prompt
slow_type "# Check health and cloud spend" 0.03
sleep 0.3

prompt
slow_type "curl -s localhost:8000/health | python3 -m json.tool" 0.02
sleep 0.5

cat << 'HEALTH'
{
    "status": "operational",
    "burst_mode": "edge_burst",
    "backends": {
        "local":  { "status": "healthy", "queue_depth": 2, "avg_latency_ms": 145 },
        "cloud":  { "status": "healthy", "queue_depth": 0, "avg_latency_ms": 320 }
    },
    "cost": {
        "daily_budget_usd": 5.00,
        "spent_today_usd": 0.47,
        "remaining_usd": 4.53,
        "requests_to_cloud_today": 235
    }
}
HEALTH

sleep 2.5

# ── CTA ───────────────────────────────────────
echo ""
echo -e "${BOLD}Open source. MIT licensed. Free forever.${RESET}"
sleep 0.5
echo -e "${CYAN}github.com/aiburstcloud/aiburstcloud${RESET}"
sleep 0.5
echo -e "${CYAN}aiburstcloud.com${RESET}"
sleep 3
