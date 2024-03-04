{ inputs, outputs, stateVersion, ... }:

with inputs.nixpkgs.lib;
with inputs.home-manager.lib;

rec {
  startsWith = value: subValue: (builtins.substring 0 (builtins.stringLength subValue) value) == subValue;

  mkNixosConfiguration = { authorizedKeys, hostname, users, sudoers, desktop, iso, platform }:
    let
      headless = desktop == null;
    in
    nixosSystem {
      # Pass flake inputs to our config
      specialArgs = {
        inherit inputs outputs hostname platform stateVersion authorizedKeys users sudoers;
        vscode-extensions = inputs.nix-vscode-extensions.extensions.${platform};

        desktop = {
          type = desktop;
          preset = "sane";
          isHeadless = headless;
          isNotHeadless = !headless;
          isGnome = startsWith desktop "gnome";
          isPlasma = startsWith desktop "plasma";
        };
      };

      modules = [
        ../defaults/configuration.nix
      ] ++ (optionals (iso) [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-${if headless then "minimal" else "graphical-calamares"}.nix"
      ]);
    };

  mkHost = { authorizedKeys ? null, hostname, users, sudoers ? users, desktop ? null, iso ? false, platform ? "x86_64-linux" }: {
    ${hostname} = mkNixosConfiguration {
      inherit authorizedKeys hostname users sudoers desktop iso platform;
    };
  };

  mkHosts = { authorizedKeys ? null, hosts }: attrsets.mergeAttrsList (map (x: mkHost (x)) hosts);
}
