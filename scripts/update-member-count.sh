#!/bin/bash
# Weekly Skool member count updater for masterzone.edu.pl
# Fetches totalMembers from Skool and updates stats.json + git push
# Cron: 0 9 * * 1  (Monday 9:00)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATS_FILE="$REPO_DIR/stats.json"
LOG_FILE="/tmp/masterzone-member-update.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"; }

log "Starting member count update"

COUNT=$(curl -s -L \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" \
  "https://www.skool.com/masterzone/about" \
  | grep -oE '"totalMembers":[0-9]+' \
  | head -1 \
  | grep -oE '[0-9]+')

if [ -z "$COUNT" ] || [ "$COUNT" -lt 1 ]; then
  log "ERROR: Could not fetch member count (got: '$COUNT')"
  exit 1
fi

OLD_COUNT=$(python3 -c "import json; print(json.load(open('$STATS_FILE'))['memberCount'])" 2>/dev/null || echo "?")
log "Skool members: $COUNT (was: $OLD_COUNT)"

if [ "$COUNT" = "$OLD_COUNT" ]; then
  log "No change, skipping"
  exit 0
fi

NOW=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
cat > "$STATS_FILE" <<EOF
{
  "memberCount": $COUNT,
  "lastUpdated": "$NOW",
  "source": "auto-skool-scrape"
}
EOF

cd "$REPO_DIR"
git add stats.json
git commit -m "Update member count: $OLD_COUNT → $COUNT"
git push origin main

log "Done: $OLD_COUNT → $COUNT, pushed to GitHub"
