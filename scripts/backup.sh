#!/bin/bash
echo "⏰ 50 Hours Milestone! Backing up everything..."

# 1. Zip बनाओ
tar -czvf /tmp/workspace_backup.tar.gz -C /workspaces/ .

# 2. 'hf' का इस्तेमाल करके अपलोड मारो
hf upload $HF_REPO_ID /tmp/workspace_backup.tar.gz workspace_backup.tar.gz --repo-type dataset --token $HF_TOKEN

rm /tmp/workspace_backup.tar.gz
echo "✅ Backup Complete! 😈"
