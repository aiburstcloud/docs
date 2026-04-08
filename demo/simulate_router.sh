#!/usr/bin/env bash
# Simulated AI Burst Cloud output for demo recording

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

simulate_startup() {
    echo -e "${GREEN}INFO${RESET}:     AI Burst Cloud v0.1.0"
    sleep 0.3
    echo -e "${GREEN}INFO${RESET}:     Burst mode: ${CYAN}edge_burst${RESET} (local primary, cloud overflow)"
    sleep 0.2
    echo -e "${GREEN}INFO${RESET}:     Local backend: http://localhost:11434 ${GREEN}healthy${RESET}"
    sleep 0.2
    echo -e "${GREEN}INFO${RESET}:     Cloud backend: https://api.runpod.ai/v2/*** ${GREEN}healthy${RESET}"
    sleep 0.2
    echo -e "${GREEN}INFO${RESET}:     Daily cloud budget: \$5.00"
    sleep 0.2
    echo -e "${GREEN}INFO${RESET}:     Uvicorn running on ${BOLD}http://0.0.0.0:8000${RESET}"
    sleep 0.3
    echo ""
}

simulate_request() {
    local backend=$1 reason=$2 budget=$3 sensitivity=$4 latency=$5
    local color=$GREEN
    [ "$backend" = "cloud" ] && color=$YELLOW

    echo -e "${DIM}$(date '+%H:%M:%S')${RESET}  Route: ${color}${backend}${RESET}  | reason=${reason} | budget=\$${budget} | sensitivity=${sensitivity} | ${latency}ms"
}

simulate_health() {
    cat << 'HEALTH'
{
  "status": "operational",
  "burst_mode": "edge_burst",
  "backends": {
    "local": {
      "status": "healthy",
      "queue_depth": 2,
      "avg_latency_ms": 145
    },
    "cloud": {
      "status": "healthy",
      "queue_depth": 0,
      "avg_latency_ms": 320
    }
  },
  "cost": {
    "daily_budget_usd": 5.0,
    "spent_today_usd": 0.47,
    "remaining_usd": 4.53,
    "requests_to_cloud_today": 235
  }
}
HEALTH
}

case "${1:-startup}" in
    startup)
        simulate_startup
        ;;
    route-local)
        simulate_request "local" "local_available" "${2:-5.00}" "public" "142"
        ;;
    route-cloud)
        simulate_request "cloud" "local_overloaded_burst_to_cloud" "${2:-4.98}" "public" "318"
        ;;
    route-sensitive)
        simulate_request "local" "sensitive_data_force_local" "${2:-4.98}" "sensitive" "156"
        ;;
    burst-sequence)
        simulate_request "local"  "local_available" "5.00" "public" "142"
        sleep 0.4
        simulate_request "local"  "local_available" "5.00" "public" "138"
        sleep 0.4
        simulate_request "local"  "local_available" "5.00" "public" "151"
        sleep 0.4
        simulate_request "local"  "local_available" "5.00" "public" "289"
        sleep 0.3
        simulate_request "local"  "local_available" "5.00" "public" "445"
        sleep 0.3
        echo -e "${YELLOW}WARN${RESET}:     Local queue depth 5/5 — bursting to cloud"
        sleep 0.3
        simulate_request "cloud"  "local_overloaded_burst_to_cloud" "4.98" "public" "318"
        sleep 0.3
        simulate_request "cloud"  "local_overloaded_burst_to_cloud" "4.96" "public" "295"
        sleep 0.3
        simulate_request "local"  "sensitive_data_force_local" "4.96" "sensitive" "156"
        sleep 0.3
        simulate_request "cloud"  "local_overloaded_burst_to_cloud" "4.94" "public" "301"
        ;;
    health)
        simulate_health
        ;;
esac
