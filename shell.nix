# Shell for bootstrapping flake-enabled nix and home-manager
# Enter it through 'nix develop' or (legacy) 'nix-shell'

{ pkgs ? (import ./nixpkgs.nix) { } }:
pkgs.mkShell {
  # Enable experimental features without having to specify the argument
  NIX_CONFIG = "experimental-features = nix-command flakes";
  buildInputs = with pkgs; [
    nix
    home-manager
    nixpkgs-fmt
    nixd
  ];
}
