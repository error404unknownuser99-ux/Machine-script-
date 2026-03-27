#!/bin/bash
echo "🚇 Starting Cloudflare Tunnel..."

# 1. Cloudflared इंस्टॉल करो (अगर पहले से नहीं है)
if ! command -v cloudflared &> /dev/null
then
    echo "Installing Cloudflared..."
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
    sudo dpkg -i cloudflared-linux-amd64.deb
    rm cloudflared-linux-amd64.deb
fi

# 2. टनल चालू करो (मान लो तुम्हारा वेब ऐप/कोड 8000 पोर्ट पर चल रहा है)
# पोर्ट अपने हिसाब से चेंज कर लेना
TARGET_PORT=8000 
nohup cloudflared tunnel --url http://localhost:$TARGET_PORT > /tmp/tunnel.log 2>&1 &

# 3. URL जनरेट होने का वेट करो (5-10 सेकंड)
sleep 10

# 4. URL निकालो
TUNNEL_URL=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' /tmp/tunnel.log | head -1)

if [ -z "$TUNNEL_URL" ]; then
    echo "❌ Failed to get Tunnel URL."
else
    echo "✅ Tunnel URL: $TUNNEL_URL"
    
    # 5. Render API को URL भेजो ताकि Supabase में अपडेट हो सके
    CODESPACE_NAME=$(hostname) # Codespace का नाम
    
    echo "📡 Sending URL to Render API..."
    curl -X POST "$RENDER_API_URL/update-url" \
         -H "Content-Type: application/json" \
         -d "{\"id\": \"$CODESPACE_NAME\", \"url\": \"$TUNNEL_URL\"}"
fi
