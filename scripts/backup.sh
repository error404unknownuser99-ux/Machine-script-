#!/bin/bash
echo "⏰ 50 Hours Milestone! Backing up your hard work..."

# 📦 Zip बनाओ पर 'scripts' और '.git' को छोड़ दो (ताकि पुराना कोड वापस ना आए)
tar -czvf /tmp/workspace_backup.tar.gz \
    --exclude='./Machine-script-/scripts' \
    --exclude='./Machine-script-/.git' \
    -C /workspaces/ .

# ⬆️ Hugging Face पर अपलोड
hf upload $HF_REPO_ID /tmp/workspace_backup.tar.gz workspace_backup.tar.gz --repo-type dataset --token $HF_TOKEN

rm /tmp/workspace_backup.tar.gz
echo "✅ Fresh Soul Saved (No Old Scripts)! 😈"
