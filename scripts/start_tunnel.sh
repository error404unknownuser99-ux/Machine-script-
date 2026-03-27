#!/bin/bash
echo "🚀 Initiating God-Mode Tmate Setup..."

# 1. भाड़ में जाए APT/APK, सीधा Binary डाउनलोड मारो! 😈
if ! command -v tmate &> /dev/null; then
    echo "📥 Forcing Tmate Installation via Static Binary..."
    wget -q https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-amd64.tar.xz -O /tmp/tmate.tar.xz
    tar -xf /tmp/tmate.tar.xz -C /tmp/
    sudo mv /tmp/tmate-2.4.0-static-linux-amd64/tmate /usr/local/bin/tmate
    sudo chmod +x /usr/local/bin/tmate
    rm -rf /tmp/tmate*
    echo "✅ Tmate Forced Install Complete!"
fi

# 2. Tmate सेशन लॉन्च करो (बिना रुके) 🛰️
echo "🛰️ Launching Tmate Session..."
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
    CODESPACE_NAME=$(hostname)
    FINAL_URL="$TMATE_WEB" # UI पर सिर्फ Web URL दिखाएंगे, साफ लगेगा
    
    echo "📡 Sending links to Render..."
    curl -X POST "$RENDER_API_URL/update-url" \
         -H "Content-Type: application/json" \
         -d "{\"id\": \"$CODESPACE_NAME\", \"url\": \"$FINAL_URL\"}"
fi
