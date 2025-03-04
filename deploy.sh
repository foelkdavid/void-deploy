#!/bin/bash
source ./vars.sh

echo " "
sleep 1 && echo "####################"
echo "Updating Repos"
sudo xbps-install -Syu


echo " "
sleep 1 && echo "####################"
echo "Installing Packages"
for pkg in "${PACKAGES[@]}"; do
    echo "Installing $pkg..."
    sudo xbps-install -Sy "$pkg"
done


echo " "
sleep 1 && echo "####################"
echo "Enabling Services"
for service in "${SERVICES[@]}"; do
    echo "Enabling $service..."
    sudo ln -s /etc/sv/$service /var/service/$service
done


echo " "
sleep 1 && echo "####################"
echo "Add user to groups"
for group in "${USERGROUPS[@]}"; do
    echo "Adding user to $group..."
    sudo usermod -aG $group $USER
done


echo " "
sleep 1 && echo "####################"
echo "Setup Pipewire"
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/10-wireplumber.conf
sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/20-pipewire-pulse.conf
sudo ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop


echo " "
sleep 1 && echo "####################"
echo "Installing GPU-Drivers"
case "$GPU_DRIVER" in
    intel)
        echo "-> intel"
        sudo xbps-install -Sy mesa-dri vulkan-loader mesa-vulkan-intel intel-video-accel
        ;;
    amd)
        echo "-> amd"
        sudo xbps-install -Sy mesa-dri vulkan-loader mesa-vulkan-radeon mesa-vaapi
        ;;
    nvidia)
        echo "-> nvidia"
        echo "TODO"
        ;;
    *)
        echo "-> ???"
        echo "No Driver defined, skipping..."
        ;;
esac

echo " "
sleep 1 && echo "####################"
echo "Copying rc.local"
sudo cp $PWD/etc/rc.local /etc/rc.local


echo " "
sleep 1 && echo "####################"
echo "Copying profile.d"
sudo cp -r $PWD/etc/profile.d/* /etc/profile.d


echo " "
sleep 1 && echo "####################"
echo "Fetching + Linking Fonts"
cd $PWD/dotfiles/fonts
./getfonts.sh
ln -vs /home/$USER/.config/fonts /home/$USER/.fonts
cd $OLDPWD

echo " "
sleep 1 && echo "####################"
echo "Linking Dotfiles"
ln -vs $PWD/dotfiles/alacritty /home/$USER/.config/alacritty

ln -vs $PWD/dotfiles/zsh /home/$USER/.config/zsh
ln -vs $PWD/dotfiles/zsh/zshrc /home/$USER/.zshrc
cd $PWD/dotfiles/zsh
./getplugins.sh
cd $OLDPWD

ln -vs $PWD/dotfiles/tofi /home/$USER/.config/tofi

ln -vs $PWD/dotfiles/mako /home/$USER/.config/mako

ln -vs $PWD/dotfiles/gtk-3.0 /home/$USER/.config/gtk-3.0

ln -vs $PWD/dotfiles/waybar /home/$USER/.config/waybar

ln -vs $PWD/dotfiles/nvim /home/$USER/.config/nvim

ln -vs $PWD/dotfiles/river /home/$USER/.config/river



echo " "
sleep 1 && echo "####################"
echo "Changing Shell"
chsh -s $USERSHELL

echo " "
sleep 1 && echo "####################"
echo "All Done!"
echo "Please Reboot."
