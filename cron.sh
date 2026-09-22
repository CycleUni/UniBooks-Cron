#!/bin/sh

DEFAULT_URLS="https://api.unibooks.app/api/cron/waitlist-notify/,https://api.unibooks.app/api/cron/meetup-reminder/"

# Support CRON_TARGET_URLS or CRON_TARGET_URL or CLI arguments, fallback to DEFAULT_URLS
TARGET_URLS="${CRON_TARGET_URLS:-${CRON_TARGET_URL:-$DEFAULT_URLS}}"

# If command-line arguments are provided, use them
if [ "$#" -gt 0 ]; then
  TARGET_URLS="$*"
fi

if [ -z "$CRON_SECRET" ]; then
  echo "Error: CRON_SECRET environment variable is not set."
  exit 1
fi

echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] Starting Cron Job..."

# Normalize comma or newline separated URLs into space-separated list
FORMATTED_URLS=$(echo "$TARGET_URLS" | tr ',' ' ' | tr '\n' ' ')

EXIT_CODE=0

for url in $FORMATTED_URLS; do
  url=$(echo "$url" | xargs)
  [ -z "$url" ] && continue

  # Filter out non-existent base /api/cron or /api/cron/ root endpoint
  case "$url" in
    */api/cron|*/api/cron/)
      echo "----------------------------------------"
      echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] Skipping $url (root /api/cron has no handler, please use sub-endpoints)"
      continue
      ;;
  esac

  echo "----------------------------------------"
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] Calling: $url"

  # Perform POST request, capturing HTTP response and status code
  HTTP_RESPONSE=$(curl -sS -w "\n%{http_code}" -X POST "$url" \
       -H "Authorization: Bearer $CRON_SECRET" \
       --max-time 60)
  CURL_STATUS=$?

  if [ $CURL_STATUS -ne 0 ]; then
    echo "Error: curl failed with exit code $CURL_STATUS for $url"
    EXIT_CODE=1
    continue
  fi

  # Extract body and HTTP status code
  HTTP_BODY=$(echo "$HTTP_RESPONSE" | sed '$d')
  HTTP_CODE=$(echo "$HTTP_RESPONSE" | tail -n 1)

  echo "Response HTTP Status: $HTTP_CODE"
  if [ -n "$HTTP_BODY" ]; then
    echo "Response Body: $HTTP_BODY"
  fi

  if [ "$HTTP_CODE" -lt 200 ] || [ "$HTTP_CODE" -ge 300 ]; then
    echo "Warning: Target returned non-2xx status code: $HTTP_CODE"
    EXIT_CODE=1
  fi
done

echo "----------------------------------------"
if [ $EXIT_CODE -eq 0 ]; then
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] All Cron Jobs finished successfully."
else
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] One or more Cron Jobs failed."
fi

exit $EXIT_CODE
