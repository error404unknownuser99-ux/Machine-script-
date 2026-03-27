#!/bin/bash
# 📦 Phoenix Engine: Persistent Internal Storage Backup

echo "⏰ Initiating Milestone Backup... (Saving your hard work)"

# 1. 🧹 पुरानी फ़ाइल साफ़ करो (अगर /tmp में पड़ी हो)
rm -f /tmp/workspace_backup.tar.gz

# 2. 📦 'Internal Storage' की ज़िप बनाओ (The Smart Way)
# हम /home/codespace और /workspaces को लपेट रहे हैं, पर कचरा (Scripts, Git, Cache) बाहर!
echo "📦 Compressing Data... (Excluding the ghosts of the past)"

tar --exclude='.git' \
    --exclude='.cache' \
    --exclude='.bash_history' \
    --exclude='.vscode-server' \
    --exclude='*/Machine-script-/scripts' \
    -czvf /tmp/workspace_backup.tar.gz /home/codespace /workspaces

# 3. ⬆️ Hugging Face पर 'Soul' अपलोड करो
if [ -f "/tmp/workspace_backup.tar.gz" ]; then
    echo "🚀 Uploading to Hugging Face Locker (jerecom/_)..."
    
    # 'hf' का इस्तेमाल करके सीधा अपलोड
    hf upload $HF_REPO_ID /tmp/workspace_backup.tar.gz workspace_backup.tar.gz --repo-type dataset --token $HF_TOKEN
    
    # 4. ✨ 'The Final Paint' (काम खत्म, अब सफाई!)
    rm /tmp/workspace_backup.tar.gz
    echo "✅ Backup Successful! Your soul is immortal now. 😈"
    
    # थोड़ा रुककर पूरी स्क्रीन साफ़ और प्रॉम्ट छोटा कर दो
    sleep 2
    clear
    export PS1='$ '
else
    echo "❌ CRITICAL ERROR: Backup failed! Check disk space or permissions."
    exit 1
fi
