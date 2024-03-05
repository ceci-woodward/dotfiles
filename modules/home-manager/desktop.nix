{ lib, config, pkgs, desktop, ... }:

with lib;

let
  cfg = config.dotfiles.desktop;
  profileHashSub = with types; submodule
    {
      options = {
        url = mkOption {
          description = "Your profile picture";
          type = nullOr (types.str);
          default = null;
        };

        sha256 = mkOption {
          description = "Your profile picture's hash";
          type = types.str;
          default = lib.fakeHash;
        };
      };
    };
in
{
  options.dotfiles.desktop = with types;
    {
      enable = mkEnableOption "desktop settings";

      systemFavorites = mkOption {
        description = "Favorites specified by the desktop environment";
        type = nullOr (listOf (types.str));
        default = [ ];
      };

      favorites = mkOption {
        description = "Any apps you'd like to favorite. (used by various dock extensions)";
        type = listOf (types.str);
        default = [ ];
      };

      picture = mkOption {
        description = "The profile picture path or url + hash";
        type = nullOr (types.oneOf ([ types.path profileHashSub ]));
      };

      cursor = {
        enable = mkEnableOption "cursor overrides";

        url = mkOption {
          description = "The url of the cursor tar file";
          type = types.str;
        };

        hash = mkOption {
          description = "The hash of the tar file";
          type = types.str;
        };

        name = mkOption {
          description = "The hash of the tar file";
          type = types.str;
        };
      };
    };

  config = mkIf (cfg.enable) {
    home.pointerCursor = mkIf (cfg.cursor.enable)
      {
        gtk.enable = true;
        x11.enable = true;
        name = cfg.cursor.name;
        package = pkgs.runCommand "moveUp" { } ''
          mkdir -p $out/share/icons
          ln -s ${pkgs.fetchzip {
            url = cfg.cursor.url;
            hash = cfg.cursor.hash;
          }} $out/share/icons/${cfg.cursor.name}
        '';
      };

    home.file.".face" = mkIf (cfg.picture != null) {
      source = if builtins.typeOf (cfg.picture) == "path" then cfg.picture else
      builtins.fetchurl {
        url = cfg.picture.url;
        sha256 = cfg.picture.sha256;
      };
    };
  };
}
