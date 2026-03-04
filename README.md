# void-deploy
Sets up Voidlinux + River
-> Also a foolish attempt to keep configs in sync between my devices.

# Usage

## UEFI Systems
1. Boot the Void Linux live ISO.
2. Clone this repo: `git clone <repo> ~/.local/deploy && cd ~/.local/deploy`
3. Edit `vars.sh`:
   - Set `BOOTLOADER_TYPE=uefi`
   - Set `BOOT_DISK` to your target disk (e.g. `/dev/sda` or `/dev/nvme0n1`)
   - Set `BOOT_PARTITION_SIZE` (e.g. `512M`)
4. Run `./install.sh` — this will:
   - Create a GPT partition table with an EFI System Partition (FAT32) and a root partition (ext4)
   - Install and configure GRUB for EFI (`grub-x86_64-efi`)
5. Complete the Void Linux base installation into `/mnt`.
6. Reboot, login to your sudo user, and run `./deploy.sh`.

## BIOS Systems
1. Boot the Void Linux live ISO.
2. Clone this repo: `git clone <repo> ~/.local/deploy && cd ~/.local/deploy`
3. Edit `vars.sh`:
   - Set `BOOTLOADER_TYPE=bios`
   - Set `BOOT_DISK` to your target disk (e.g. `/dev/sda`)
   - Set `BOOT_PARTITION_SIZE` (e.g. `512M`)
4. Run `./install.sh` — this will:
   - Create an MBR partition table with a boot partition (ext4) and a root partition (ext4)
   - Install and configure GRUB for BIOS (`grub` / `i386-pc` target)
5. Complete the Void Linux base installation into `/mnt`.
6. Reboot, login to your sudo user, and run `./deploy.sh`.

### Disk Partitioning Examples

**UEFI (GPT)**
```
/dev/sda1   512M   EFI System Partition (FAT32)   /boot/efi
/dev/sda2   rest   Root partition (ext4)           /
```

**BIOS (MBR)**
```
/dev/sda1   512M   Boot partition (ext4, bootable) /boot
/dev/sda2   rest   Root partition (ext4)           /
```

### Bootloader Configuration
`install.sh` runs `grub-install` and `grub-mkconfig` automatically, targeting the system mounted at `/mnt`.
- **UEFI**: installs `grub-x86_64-efi`, target `x86_64-efi`, EFI directory `/mnt/boot/efi`, config written to `/mnt/boot/grub/grub.cfg`.
- **BIOS**: installs `grub`, target `i386-pc`, writes MBR to `BOOT_DISK`, config written to `/mnt/boot/grub/grub.cfg`.

After reboot, GRUB will load from the configured partition and boot Void Linux.

# Maintenance
All dotfiles are linked from:
`.local/deploy/dotfiles`

## Pushing Changes
1. Make changes
2. git push (ideally not into my repo lol)

## Pulling Changes
1. Git Pull
2. Enjoy
*Note: Pulling will also overwrite your vars file*
*-> Not an issue as long as you dont re-deploy*

## Overrides
Some Configs may allow for the use of Override files.

### River
The `init` file sources an `overrides` file at the end.
`.local/deploy/dotfiles/river/overrides/...` contains my device-specific overrides.
These can be linked to `~/.config/river/overrides` if desired.
