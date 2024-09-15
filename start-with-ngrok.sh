#!/bin/bash

echo "Starting Ngrok..."

# Start Ngrok in the background
ngrok http 1337 > /dev/null &
NGROK_PID=$!

# Give Ngrok some time to start
sleep 5

# Get Ngrok's public URL
ngrok_url=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')

if [ -z "$ngrok_url" ]; then
  echo "Failed to retrieve Ngrok URL."
  exit 1
fi

echo "Ngrok URL: $ngrok_url"

# Export the Ngrok URL as an environment variable
export STRAPI_URL=$ngrok_url

echo "Starting Strapi..."
# Start Strapi
npm run develop

# Clean up Ngrok process
kill $NGROK_PID
