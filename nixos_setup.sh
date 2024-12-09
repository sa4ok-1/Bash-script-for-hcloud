#!/bin/bash

# Stop on any error
set -e

echo "Updating NixOS and installing necessary packages..."

# Update nix channels and system
nix-channel --update
nixos-rebuild switch --upgrade

echo "Installing GUI, browsers, and NoMachine..."

# Append to NixOS configuration
cat << EOF >> /etc/nixos/configuration.nix

# Enable graphical interface
services.xserver.enable = true;
services.xserver.displayManager.lightdm.enable = true;
services.xserver.desktopManager.plasma5.enable = true;

# Install browsers
environment.systemPackages = with pkgs; [
  firefox
  chromium
];

# Enable NoMachine service
services.nomachine.enable = true;

# Firewall settings (optional)
networking.firewall.allowedTCPPorts = [ 4000 ];
EOF

# Rebuild the NixOS system with the new configuration
nixos-rebuild switch

echo "Setting up NoMachine..."

# Ensure NoMachine is started
systemctl enable --now nomachine

echo "Installation completed successfully!"

echo "Rebooting to apply changes..."
reboot
