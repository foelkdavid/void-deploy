#!/bin/bash
FONTS=(
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CodeNewRoman.zip"
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/ComicShannsMono.zip"
)


sleep 1 && echo "####################"
echo "Fetching fonts"
rm -rf /tmp/deploy_fonts
mkdir -p ~/.config/fonts
mkdir -p /tmp/deploy_fonts

for font in ${FONTS[@]}; do    
    cd /tmp/deploy_fonts
    curl -fLO $font
    unzip -o *.zip
done

mv -v *.otf ~/.config/fonts
rm -rf /tmp/deploy_fonts
cd $OLDPWD

echo "Fonts deployed"
