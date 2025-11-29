#!/bin/bash

# VSCode 설정 디렉토리 (Mac 기준)
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

# 설정 파일 심볼릭 링크 생성 (수정 시 자동 동기화)
echo "🔗 Linking VSCode settings..."
ln -sf "$HOME/dotfiles/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
ln -sf "$HOME/dotfiles/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

# 확장 프로그램 일괄 설치
if [ -f "$HOME/dotfiles/vscode/extensions.txt" ]; then
    echo "📦 Installing VSCode extensions..."
    cat "$HOME/dotfiles/vscode/extensions.txt" | xargs -L 1 code --install-extension
else
    echo "⚠️ extensions.txt not found, skipping extension installation."
fi

echo "✅ VSCode setup complete!"
