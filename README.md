# UniBooks Cron Job

This repository serves as a lightweight cron job worker to replace Vercel Cron. 
It uses an Alpine Linux Docker container to ping the `UniBooks-BE` API at scheduled intervals via a `curl` POST request.

## How it works

When deployed as a **Cron Job Service** on Railway, the container will start, execute the `cron.sh` script, hit the target API endpoint, and then immediately shut down to save resources.

## Deployment on Railway

1. Create a new **GitHub Repo** service in your Railway project and select this repository.
2. In the Service **Settings**, set a **Cron Schedule** (e.g., `0 0 * * *` for midnight).
3. In the Service **Variables**, add the following required environment variables:
   - `CRON_TARGET_URL`: The full URL of your backend cron endpoint (e.g., `https://api.yourdomain.com/api/cron`).
   - `CRON_SECRET`: The authorization bearer token used to authenticate with your API.

