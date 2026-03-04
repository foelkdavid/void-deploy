#!/bin/bash
# Pre-install script: partitions the target disk and sets up the bootloader
# for both BIOS (GRUB) and UEFI (EFI) systems.
# Run this BEFORE deploy.sh on a fresh Void Linux installation.
source ./vars.sh

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
die() { echo "ERROR: $*" >&2; exit 1; }

confirm() {
    read -r -p "$1 [y/N] " answer
    case "$answer" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

# ---------------------------------------------------------------------------
# Detect firmware type (override with BOOTLOADER_TYPE in vars.sh)
# ---------------------------------------------------------------------------
detect_firmware() {
    if [ -d /sys/firmware/efi ]; then
        echo "uefi"
    else
        echo "bios"
    fi
}

DETECTED=$(detect_firmware)
echo " "
sleep 1 && echo "####################"
echo "Firmware Detection"
echo "-> Detected: $DETECTED"
echo "-> Configured (vars.sh): $BOOTLOADER_TYPE"

if [ "$DETECTED" != "$BOOTLOADER_TYPE" ]; then
    echo "WARNING: Detected firmware ($DETECTED) does not match BOOTLOADER_TYPE ($BOOTLOADER_TYPE)."
    confirm "Continue anyway?" || die "Aborted by user."
fi

# ---------------------------------------------------------------------------
# Sanity checks
# ---------------------------------------------------------------------------
[ -b "$BOOT_DISK" ] || die "BOOT_DISK '$BOOT_DISK' is not a valid block device. Set it in vars.sh."
command -v parted >/dev/null 2>&1 || die "'parted' is not installed. Run: sudo xbps-install -Sy parted"

echo " "
sleep 1 && echo "####################"
echo "Disk Partitioning"
echo "-> Target disk: $BOOT_DISK"
echo "-> Boot partition size: $BOOT_PARTITION_SIZE"
echo "WARNING: All data on $BOOT_DISK will be destroyed!"
confirm "Proceed with partitioning $BOOT_DISK?" || die "Aborted by user."

# ---------------------------------------------------------------------------
# Partition the disk
# ---------------------------------------------------------------------------
case "$BOOTLOADER_TYPE" in
    uefi)
        echo "-> Creating GPT partition table with EFI System Partition..."
        sudo parted -s "$BOOT_DISK" \
            mklabel gpt \
            mkpart ESP fat32 1MiB "$BOOT_PARTITION_SIZE" \
            set 1 esp on \
            mkpart primary ext4 "$BOOT_PARTITION_SIZE" 100%

        # Derive partition names (handle both /dev/sdX and /dev/nvme0nX)
        if echo "$BOOT_DISK" | grep -q 'nvme\|mmcblk'; then
            EFI_PART="${BOOT_DISK}p1"
            ROOT_PART="${BOOT_DISK}p2"
        else
            EFI_PART="${BOOT_DISK}1"
            ROOT_PART="${BOOT_DISK}2"
        fi

        echo "-> Formatting EFI partition ($EFI_PART) as FAT32..."
        sudo mkfs.vfat -F32 "$EFI_PART"

        echo "-> Formatting root partition ($ROOT_PART) as ext4..."
        sudo mkfs.ext4 "$ROOT_PART"

        echo "-> Mounting partitions..."
        sudo mount "$ROOT_PART" /mnt
        sudo mkdir -p /mnt/boot/efi
        sudo mount "$EFI_PART" /mnt/boot/efi
        ;;

    bios)
        echo "-> Creating MBR partition table..."
        sudo parted -s "$BOOT_DISK" \
            mklabel msdos \
            mkpart primary ext4 1MiB "$BOOT_PARTITION_SIZE" \
            set 1 boot on \
            mkpart primary ext4 "$BOOT_PARTITION_SIZE" 100%

        if echo "$BOOT_DISK" | grep -q 'nvme\|mmcblk'; then
            BOOT_PART="${BOOT_DISK}p1"
            ROOT_PART="${BOOT_DISK}p2"
        else
            BOOT_PART="${BOOT_DISK}1"
            ROOT_PART="${BOOT_DISK}2"
        fi

        echo "-> Formatting boot partition ($BOOT_PART) as ext4..."
        sudo mkfs.ext4 "$BOOT_PART"

        echo "-> Formatting root partition ($ROOT_PART) as ext4..."
        sudo mkfs.ext4 "$ROOT_PART"

        echo "-> Mounting partitions..."
        sudo mount "$ROOT_PART" /mnt
        sudo mkdir -p /mnt/boot
        sudo mount "$BOOT_PART" /mnt/boot
        ;;

    *)
        die "Unknown BOOTLOADER_TYPE '$BOOTLOADER_TYPE'. Use 'bios' or 'uefi' in vars.sh."
        ;;
esac

echo "-> Partitioning complete."

# ---------------------------------------------------------------------------
# Install base system (void-installer / XBPS bootstrap is assumed done)
# This section handles only bootloader installation.
# ---------------------------------------------------------------------------
echo " "
sleep 1 && echo "####################"
echo "Bootloader Installation"

case "$BOOTLOADER_TYPE" in
    uefi)
        command -v grub-install >/dev/null 2>&1 || \
            sudo xbps-install -Sy grub-x86_64-efi efibootmgr
        echo "-> Installing GRUB (EFI) to $EFI_PART..."
        sudo grub-install --target=x86_64-efi \
            --efi-directory=/mnt/boot/efi \
            --boot-directory=/mnt/boot \
            --bootloader-id=void \
            --recheck
        sudo grub-mkconfig -o /mnt/boot/grub/grub.cfg
        echo "-> GRUB (EFI) installed."
        ;;

    bios)
        command -v grub-install >/dev/null 2>&1 || \
            sudo xbps-install -Sy grub
        echo "-> Installing GRUB (BIOS) to $BOOT_DISK..."
        sudo grub-install --target=i386-pc \
            --boot-directory=/mnt/boot \
            --recheck \
            "$BOOT_DISK"
        sudo grub-mkconfig -o /mnt/boot/grub/grub.cfg
        echo "-> GRUB (BIOS) installed."
        ;;
esac

echo " "
sleep 1 && echo "####################"
echo "Pre-install complete."
echo "You can now run deploy.sh to set up your environment."
