# auto suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.config/zsh/plugins/zsh-autosuggestions

# syntax hightlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zsh/plugins/zsh-syntax-highlighting

# autocompletion
git clone https://github.com/marlonrichert/zsh-autocomplete.git $HOME/.config/zsh/plugins/zsh-autocomplete

# git completion
git clone --single-branch --depth 1 https://github.com/ohmyzsh/ohmyzsh.git /tmp/ohmyzsh
cp -r /tmp/ohmyzsh/plugins/gitfast $HOME/.config/zsh/plugins/
rm -rf /tmp/ohmyzsh
