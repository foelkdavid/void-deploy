#!/bin/bash

# intel,amd,nvidia,rpi5
GPU_DRIVER=amd
USERSHELL=/usr/bin/zsh

# bios,uefi
BOOTLOADER_TYPE=uefi
# Target disk for installation (e.g. /dev/sda, /dev/nvme0n1)
BOOT_DISK=/dev/sda
# Size of the boot/EFI partition (e.g. 512M, 1G)
BOOT_PARTITION_SIZE=512M

USERGROUPS=(
    users
    _seatd
    wheel
    audio
    video
    bluetooth
)

PACKAGES=(
    seatd
    dbus
    pipewire
    bluez
    libspa-bluetooth
    unzip
    pass
    swaybg
    swaylock
    socklog-void
    zsh
    noto-fonts-ttf
    noto-fonts-emoji
    neovim
    alacritty
    wlr-randr
    wl-clipboard
    river
    Waybar
    waylock
    slurp
    grim
    wl-copy
    firefox
    tofi
    git
    mako
    Thunar
    fastfetch
    btop
    htop
    NetworkManager
    curl
    tmux
)

SERVICES=(
    NetworkManager
    seatd
    dbus
    bluetoothd
    nanoklogd
    socklog-unix
)
