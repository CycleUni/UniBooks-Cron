# UniBooks Cron Job

This repository serves as a lightweight cron job worker to replace Vercel Cron. 
It uses an Alpine Linux Docker container to ping the `UniBooks-BE` API at scheduled intervals via `curl` POST requests.

## How it works

When deployed as a **Cron Job Service** on Railway, the container will start, execute the `cron.sh` script, hit one or multiple target API endpoints, and then immediately shut down to save resources.

## Deployment on Railway

1. Create a new **GitHub Repo** service in your Railway project and select this repository.
2. In the Service **Settings**, set a **Cron Schedule** (e.g., `*/10 * * * *` for every 10 minutes or `0 0 * * *` for midnight).
3. In the Service **Variables**, add the following environment variables:
   - `CRON_TARGET_URL` or `CRON_TARGET_URLS`: One or more target endpoints separated by commas or spaces.
     - Example: `https://api.yourdomain.com/api/cron/meetup-reminder/,https://api.yourdomain.com/api/cron/waitlist-notify/`
   - `CRON_SECRET`: The authorization bearer token used to authenticate with your API.

### Available Endpoints in UniBooks-BE:
- `/api/cron/meetup-reminder/`: Notifies buyers and sellers when an accepted order's meetup is within the next hour (Recommended schedule: `*/10 * * * *`).
- `/api/cron/waitlist-notify/`: Notifies users about new listings matching their book waitlists (Recommended schedule: `0 0 * * *`).
- `/api/cron/cleanup/`: Cleans up orphaned books with no listings and no subscriptions.
