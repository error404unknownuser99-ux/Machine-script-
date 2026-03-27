#!/bin/bash
# 🛠️ Universal Auto-Setup (Final Fixed Version)

# 1. Install dependencies (Ubuntu/Alpine)
if [ -f /etc/alpine-release ]; then
    sudo apk add python3 py3-pip curl wget tar libc6-compat --no-cache
elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
    sudo apt update && sudo apt install python3-pip curl wget tar -y
fi

# 2. Install Hugging Face Hub
pip install huggingface_hub --break-system-packages --no-cache-dir || pip install huggingface_hub --no-cache-dir

echo "🔍 Checking for backup using 'hf'..."
# सीधा hf कमांड यूज़ करो, ये 100% काम करेगा
hf download $HF_REPO_ID workspace_backup.tar.gz --repo-type dataset --token $HF_TOKEN --local-dir /tmp/ || echo "⚠️ No backup found."

if [ -f "/tmp/workspace_backup.tar.gz" ]; then
    echo "📦 Restoring data..."
    tar -xzvf /tmp/workspace_backup.tar.gz -C /workspaces/
    rm /tmp/workspace_backup.tar.gz
    echo "✅ Restore Done!"
fi
