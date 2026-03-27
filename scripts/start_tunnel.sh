#!/bin/bash
echo "🚇 Starting Cloudflare Tunnel (Auto-Pilot)..."

# 1. Cloudflared इंस्टॉल करना (Alpine compatible)
if ! command -v cloudflared &> /dev/null
then
    echo "📥 Downloading Cloudflared..."
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /tmp/cloudflared
    chmod +x /tmp/cloudflared
    sudo mv /tmp/cloudflared /usr/local/bin/
fi

# 2. टनल चालू करना (Background में)
# Target port 8000 सेट है, अपने हिसाब से बदल लेना
nohup cloudflared tunnel --url http://localhost:8000 > /tmp/tunnel.log 2>&1 &

# 3. URL का इंतज़ार करो और Render को भेजो
echo "📡 Waiting for Tunnel URL..."
sleep 15
TUNNEL_URL=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' /tmp/tunnel.log | head -1)

if [ -z "$TUNNEL_URL" ]; then
    echo "❌ Error: Tunnel link nahi mila!"
else
    echo "✅ Tunnel URL Mil Gaya: $TUNNEL_URL"
    CODESPACE_NAME=$(hostname)
    # Render को पिंग मारना
    curl -X POST "$RENDER_API_URL/update-url" \
         -H "Content-Type: application/json" \
         -d "{\"id\": \"$CODESPACE_NAME\", \"url\": \"$TUNNEL_URL\"}"
fi
