# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ config, lib, pkgs, ... }:

with lib;

let
  librewolf = false;
in
{
  home.shellAliases = mkIf (librewolf) {
    "firefox" = "librewolf";
  };

  programs.firefox = {
    enable = true;
    package = mkIf (librewolf) pkgs.librewolf;
    profiles.${config.home.username} = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        buster-captcha-solver
        clearurls
        onepassword-password-manager
        # predirect
        react-devtools
        reduxdevtools
        translate-web-pages
        ublock-origin
        refined-github
        bypass-paywalls-clean
        sponsorblock
        # # Missing:
        # pwas-for-firefox
      ];

      bookmarks = [
        {
          name = "";
          tags = [ "git" "sourcecode" ];
          url = "https://github.com/cecilia-sanare";
        }
        {
          name = "";
          tags = [ "youtube" ];
          url = "https://youtube.com";
        }
      ];

      search = {
        force = true;
        default = "DuckDuckGo";
        privateDefault = "DuckDuckGo";

        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
      };

      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.tabs.tabmanager.enabled" = false;
        "browser.tabs.firefox-view" = false;

        # Performance settings
        "gfx.webrender.all" = true; # Force enable GPU acceleration
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes

        # Keep the reader button enabled at all times; really don't
        # care if it doesn't work 20% of the time, most websites are
        # crap and unreadable without this
        "reader.parse-on-load.force-enabled" = true;

        # Hide the "sharing indicator", it's especially annoying
        # with tiling WMs on wayland
        "privacy.webrtc.legacyGlobalIndicator" = false;

        # Actual settings
        "app.update.auto" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.contentblocking.category" = "strict";
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "browser.discovery.enabled" = false;
        "browser.laterrun.enabled" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
          false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
          false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.pinned" = false;
        "browser.protections_panel.infoMessage.seen" = true;
        "browser.quitShortcut.disabled" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.ssb.enabled" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.suggest.openpage" = false;
        "datareporting.policy.dataSubmissionEnable" = false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.pocket.enabled" = false;
        "identity.fxaccounts.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        "layers.acceleration.force-enabled" = true;
        "mozilla.widget.use-argb-visuals" = true;
      };
    };
  };
}
