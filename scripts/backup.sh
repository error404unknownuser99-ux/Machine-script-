#!/bin/bash
echo "⏰ 50 Hours Milestone! Backing up everything..."

# 1. पूरे Workspace का Zip बनाओ
echo "📦 Packing data..."
tar -czvf /tmp/workspace_backup.tar.gz -C /workspaces/ .

# 2. Hugging Face पर अपलोड मारो
echo "⬆️ Uploading to Hugging Face..."
huggingface-cli upload $HF_REPO_ID /tmp/workspace_backup.tar.gz workspace_backup.tar.gz --repo-type dataset --token $HF_TOKEN

# 3. साफ़-सफाई
rm /tmp/workspace_backup.tar.gz
echo "✅ Everything Safe on Hugging Face! 😈"
