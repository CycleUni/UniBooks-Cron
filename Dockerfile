FROM alpine:3.18

# Install curl
RUN apk add --no-cache curl

# Set working directory
WORKDIR /app

# Copy the cron script into the container
COPY cron.sh .

# Grant execution permissions
RUN chmod +x cron.sh

# Run the script when the container starts
CMD ["./cron.sh"]

