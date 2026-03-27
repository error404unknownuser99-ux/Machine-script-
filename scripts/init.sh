#!/bin/bash
# 🛠️ Phoenix Engine: Deep-Level Setup & Auto-Automation

echo "🚀 Starting Deep-Level Tool Installation..."

# 1. 🌍 OS Detection & Dependency Installation (Ubuntu/Alpine)
# हम साले पैकेज मैनेजर को लात मारेंगे ताकि सब कुछ ज़बरदस्ती इंस्टॉल हो जाए
if [ -f /etc/alpine-release ]; then
    echo "🗻 Alpine Linux Detected! Arming the machine..."
    sudo apk update && sudo apk add python3 py3-pip curl wget tar git vim nano htop zip unzip build-base libc6-compat --no-cache
elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
    echo "🐧 Ubuntu/Debian Detected! Arming the machine..."
    sudo apt update && sudo apt install python3-pip curl wget tar git vim nano htop zip unzip build-essential -y
else
    echo "⚠️ Unknown OS! Trying basic installation..."
    sudo apt update || sudo apk update
fi

# 2. 🐍 Python Tool-Box (The Hidden Power)
echo "📦 Installing Essential Python Tools..."
# 'hf' (Hugging Face) और 'speedtest' को सीधा सिस्टम की छाती में गाड़ देंगे
pip install huggingface_hub requests tqdm speedtest-cli --break-system-packages --no-cache-dir || pip install huggingface_hub requests tqdm speedtest-cli --no-cache-dir

# 3. 🎨 'Paint & Shortcuts' (The Magic Aliases) 🪄
# अब तुम सिर्फ एक शब्द लिखकर पूरा काम कर सकोगे
echo "🔧 Setting up your personal shortcuts..."

# ~/.bashrc में जादुई कमांड्स इंजेक्ट करो
# 'clean' -> स्क्रीन साफ़ करेगा और प्रॉम्ट को '$ ' बना देगा
echo "alias clean='clear && export PS1=\"\\\$ \"'" >> ~/.bashrc

# 'restore' -> रिस्टोर स्क्रिप्ट चलाएगा और अंत में ऑटो-पेंट (clean) कर देगा
echo "alias restore='bash /workspaces/Machine-script-/scripts/restore.sh'" >> ~/.bashrc

# 4. 🧹 'Kachda' Cleanup (The Final Wipe)
# जितना भी ऊपर इंस्टॉलेशन का कचरा जमा हुआ है, उसे पूरी तरह मिटा दो
clear

# 5. 🎉 Success Message (The Welcome Screen)
echo "--------------------------------------------------------"
echo "🔥 PHOENIX ENGINE: SYSTEM ARMED & READY! 😈"
echo "--------------------------------------------------------"
echo "👉 Type 'clean'   + Enter : For a sexy \$ prompt."
echo "👉 Type 'restore' + Enter : To bring back your soul (HF Backup)."
echo "👉 All tools (Git, Vim, Python, Htop, etc.) are Live!"
echo "--------------------------------------------------------"

# 🔄 सिंक करने के लिए एक बार bashrc को रीलोड करने की कोशिश (Optional)
source ~/.bashrc 2>/dev/null || echo "💡 Please run 'source ~/.bashrc' once to activate shortcuts."
