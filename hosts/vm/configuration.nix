# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ../../mixins/nixos/desktop/settings/no-sleep
    ../../mixins/nixos/desktop/settings/no-alerts
  ];
}
