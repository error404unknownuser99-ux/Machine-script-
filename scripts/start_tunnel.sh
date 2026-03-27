#!/bin/bash
echo "🚀 Starting Universal Tmate System..."

# 1. OS को पहचानो और Tmate इंस्टॉल करो 🛠️
if command -v tmate &> /dev/null; then
    echo "✅ Tmate is already here!"
elif [ -f /etc/alpine-release ]; then
    echo "🗻 Alpine Linux Detected!"
    sudo apk update && sudo apk add tmate --no-cache
elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
    echo "🐧 Ubuntu/Debian Detected!"
    sudo apt update && sudo apt install tmate -y
else
    echo "⚠️ Unknown OS! Trying to download binary..."
    wget -q https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-amd64.tar.xz
    tar -xf tmate-2.4.0-static-linux-amd64.tar.xz
    sudo mv tmate-2.4.0-static-linux-amd64/tmate /usr/local/bin/
fi

# 2. Tmate सेशन लॉन्च करो 🛰️
echo "🛰️ Launching Tmate..."
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready

# 3. जादुई लिंक निकालो 🔑
TMATE_WEB=$(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')
TMATE_SSH=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')

if [ -z "$TMATE_WEB" ]; then
    echo "❌ Error: Tmate failed to generate link!"
else
    echo "✅ Tmate Live!"
    echo "🌐 Web: $TMATE_WEB"
    echo "🔑 SSH: $TMATE_SSH"

    # 4. Render को पिंग मारो 📡
    # पक्का कर लो कि RENDER_API_URL का एंडपॉइंट सही है
    CODESPACE_NAME=$(hostname)
    FINAL_URL="Web: $TMATE_WEB | SSH: $TMATE_SSH"
    
    echo "📡 Sending links to Render..."
    # यहाँ /update-url के पीछे स्लैश (/) का ध्यान रखना
    curl -X POST "$RENDER_API_URL/update-url" \
         -H "Content-Type: application/json" \
         -d "{\"id\": \"$CODESPACE_NAME\", \"url\": \"$FINAL_URL\"}"
fi
