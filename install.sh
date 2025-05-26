#!/bin/bash

echo "Installing simple dotfiles for Warp..."

# シンボリックリンクを作成
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc

echo "Dotfiles installed successfully!"
echo "Reload with: source ~/.zshrc"
