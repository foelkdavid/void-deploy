# void-deploy
Sets up Voidlinux + River
-> Also a foolish attempt to keep configs in sync between my devices.

# Usage
1. Install Voidlinux with a sudo user.
2. Reboot
4. Login to your sudo user
5. Clone this Repo into .local(/deploy)
6. Configure vars.sh (gpu driver mostly)
7. run deploy.sh

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
