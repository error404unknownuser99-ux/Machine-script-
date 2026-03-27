#!/bin/bash
echo "🚀 Phoenix Engine: Starting Full Auto-Setup..."

# 1. Alpine के लिए ज़रूरी टूल्स डालना (Silent mode)
sudo apk update
sudo apk add python3 py3-pip curl wget tar libc6-compat --no-cache

# 2. Python के नखरे खत्म करना (--break-system-packages के साथ)
echo "🐍 Installing Hugging Face Hub..."
pip install huggingface_hub --break-system-packages --no-cache-dir

# 3. चेक करो कि क्या HF Dataset पर पुराना बैकअप है?
echo "📥 Checking for existing backup on Hugging Face..."
# $HF_REPO_ID और $HF_TOKEN हमें Render से मिल जाएंगे
huggingface-cli download $HF_REPO_ID workspace_backup.tar.gz --repo-type dataset --token $HF_TOKEN --local-dir /tmp/ || echo "⚠️ No backup found. Starting fresh!"

# 4. अगर बैकअप मिल गया, तो उसे रिस्टोर करो
if [ -f "/tmp/workspace_backup.tar.gz" ]; then
    echo "📦 Backup found! Restoring your soul..."
    tar -xzvf /tmp/workspace_backup.tar.gz -C /workspaces/
    rm /tmp/workspace_backup.tar.gz
    echo "✅ Restore Complete!"
else
    echo "🌱 Fresh Start!"
fi
