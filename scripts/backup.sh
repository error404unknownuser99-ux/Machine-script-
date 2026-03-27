#!/bin/bash
echo "⏰ 50 Hours Reached! Initiating Backup Protocol..."

# 1. पूरे Workspace का Zip बनाओ
# (हम /workspaces फोल्डर का बैकअप ले रहे हैं, तुम चाहो तो स्पेसिफिक फोल्डर का ले सकते हो)
echo "📦 Compressing data..."
tar -czvf /tmp/workspace_backup.tar.gz -C / workspaces/

# 2. Hugging Face पर अपलोड मारो
echo "⬆️ Uploading to Hugging Face..."
huggingface-cli upload $HF_REPO_ID /tmp/workspace_backup.tar.gz workspace_backup.tar.gz --repo-type dataset --token $HF_TOKEN

# 3. कचरा साफ़ करो
rm /tmp/workspace_backup.tar.gz

echo "✅ Backup Complete! Render Bot, you can delete me now! 😈"
