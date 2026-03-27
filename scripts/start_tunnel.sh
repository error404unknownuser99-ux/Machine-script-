#!/bin/bash
echo "🚀 Initiating Persistent Tmate System..."

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

# 2. Tmate सेशन लॉन्च करो (अगर पहले से नहीं चल रहा) 🛰️
if ! tmate -S /tmp/tmate.sock list-sessions > /dev/null 2>&1; then
    echo "🛰️ Launching a new Tmate Session..."
    tmate -S /tmp/tmate.sock new-session -d
    tmate -S /tmp/tmate.sock wait tmate-ready
fi

# 3. 5 बार कोशिश करेगा लिंक निकालने की (The Looping Logic) 🔄
for i in {1..5}; do
    echo "📡 Attempt $i: Fetching Tmate links..."
    
    TMATE_WEB=$(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')
    TMATE_SSH=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')

    if [ -n "$TMATE_WEB" ] && [ -n "$TMATE_SSH" ]; then
        echo "✅ Tmate Live!"
        echo "🌐 Web: $TMATE_WEB"
        echo "🔑 SSH: $TMATE_SSH"

        # 4. Render को पिंग मारने की कोशिश (5 बार) 📡
        CODESPACE_NAME=$(hostname)
        FINAL_URL="Web: $TMATE_WEB | SSH: $TMATE_SSH"
        
        echo "📡 Attempting to notify Render..."
        RESPONSE=$(curl -o /dev/null -s -w "%{http_code}" -X POST "$RENDER_API_URL/update-url/" \
             -H "Content-Type: application/json" \
             -d "{\"id\": \"$CODESPACE_NAME\", \"url\": \"$FINAL_URL\"}")
        
        if [ "$RESPONSE" = "200" ]; then
            echo "✅ Render Notified Successfully! Mission Complete."
            exit 0 # सब सफल, अब बाहर निकलो
        else
            echo "⚠️ Render responded with HTTP $RESPONSE. Retrying..."
        fi
    else
        echo "❌ Tmate link not ready yet. Waiting..."
    fi
    sleep 10 # 10 सेकंड का इंतज़ार
done

echo "❌ CRITICAL ERROR: Could not get Tmate links or notify Render after 5 attempts."
exit 1 # 5 बार में भी फेल, तो एरर के साथ बाहर निकलो
