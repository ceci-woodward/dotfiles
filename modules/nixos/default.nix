{ config, pkgs, ... }:

let
  # Core utilities, generally don't uninstall these
  core = with pkgs; [
    gnome.gnome-terminal
    gnome.file-roller
    gnome.nautilus
    gnome.gnome-system-monitor
    baobab # Disk usage analyzer
    vim
    git
    gparted
    killall
  ];

  cli = with pkgs; [
    nixpkgs-fmt
    nixd # Nix Language Server
    autorandr
    gnumake
  ];

  apps = with pkgs; [
    vlc
    firefox
    slack
    zoom-us
    spotify
    figma-linux
    rustdesk
    obs-studio
    caprine-bin # Facebook Messenger App
    # Swap to another rest client when its available
    bruno
    # megasync
    # TODO: This doesn't do anything right now... why?
    # jellyfin-web
  ];
in
{
  imports = [
    ./1password
    ./discord
    ./gaming
  ];

  nixpkgs.config.allowUnfree = true;
  services.gnome.core-utilities.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  environment.systemPackages = core ++ cli ++ apps;
}
