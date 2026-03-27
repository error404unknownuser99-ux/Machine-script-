#!/bin/bash
# 🛠️ Phoenix Engine: Deep-Level Setup & Auto-Home Navigation

echo "🚀 Starting Deep-Level Tool Installation..."

# 1. 🌍 OS Detection & Dependency Installation (Ubuntu/Alpine)
if [ -f /etc/alpine-release ]; then
    echo "🗻 Alpine Linux Detected!"
    sudo apk update && sudo apk add python3 py3-pip curl wget tar git vim nano htop zip unzip build-base libc6-compat --no-cache
elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
    echo "🐧 Ubuntu/Debian Detected!"
    sudo apt update && sudo apt install python3-pip curl wget tar git vim nano htop zip unzip build-essential -y
fi

# 2. 🐍 Python Tool-Box
echo "📦 Installing Essential Python Tools..."
pip install huggingface_hub requests tqdm speedtest-cli --break-system-packages --no-cache-dir || pip install huggingface_hub requests tqdm speedtest-cli --no-cache-dir

# 3. 🎨 'Shortcuts & Auto-Home' (The Magic Logic) 🪄
echo "🔧 Setting up your personal environment..."

# पुराने कचरे को साफ करो (Duplicate aliases हटाओ)
sed -i '/alias clean=/d' ~/.bashrc
sed -i '/alias restore=/d' ~/.bashrc
sed -i '/cd ~/d' ~/.bashrc

# नए Shortcuts और Auto-Home जोड़ो
# 'clean' -> सिर्फ स्क्रीन साफ़ करेगा, प्रॉम्ट को नहीं छेड़ेगा (जैसा तुमने माँगा)
echo "alias clean='clear'" >> ~/.bashrc

# 'restore' -> रिस्टोर चलाएगा और अंत में ऑटो-क्लीन कर देगा
echo "alias restore='bash /workspaces/Machine-script-/scripts/restore.sh'" >> ~/.bashrc

# 🏠 Auto-Navigation: लॉगिन करते ही सीधे ~ (Home) पर पहुँचा देगा
echo "cd ~" >> ~/.bashrc

# 4. 🧹 'Kachda' Cleanup (The Final Wipe)
# इंस्टॉलेशन का सारा शोर-शराबा मिटा दो
clear

# 5. 🎉 Success Message (The Welcome Screen)
echo "--------------------------------------------------------"
echo "🔥 PHOENIX ENGINE: SYSTEM ARMED & READY! 😈"
echo "--------------------------------------------------------"
echo "👉 Your Location: Home (~) 🏠"
echo "👉 Account Name: $(whoami) 📛"
echo "--------------------------------------------------------"
echo "💡 Type 'clean'   + Enter : To wipe the terminal mess."
echo "💡 Type 'restore' + Enter : To bring back your soul (Backup)."
echo "--------------------------------------------------------"

# 🔄 फौरन घर (Home) की तरफ कूच करो
cd ~
source ~/.bashrc 2>/dev/null
