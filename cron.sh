#!/bin/sh
set -e

# Ensure required environment variables are set
if [ -z "$CRON_TARGET_URL" ]; then
  echo "Error: CRON_TARGET_URL environment variable is not set."
  exit 1
fi

if [ -z "$CRON_SECRET" ]; then
  echo "Error: CRON_SECRET environment variable is not set."
  exit 1
fi

echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] Starting Cron Job..."

# Send POST request to the target URL with the secret token
curl -sS -X POST "$CRON_TARGET_URL" \
     -H "Authorization: Bearer $CRON_SECRET"

echo ""
echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] Cron Job finished successfully."

