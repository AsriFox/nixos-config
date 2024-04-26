{ config, pkgs, inputs, ... }:
let
  # FIXME: temporary palette until catppuccin/nix is included
  palette = {
    base = "24273a";
    text = "cad3f5";
    lavender = "b7bdf8";
  };
  style = with palette; ''
    #entry {
      background-color: alpha(#${base}, 0.8);
      border: 2px solid #${base};
      border-radius: 8px;
      color: #${text};
    }
    #main {
      background-color: transparent;
      border-radius: 8px;
      color: #${text};
      font: 14px FiraCode Nerd Font;
    }
    #plugin {
      background-color: transparent;
    }
    #match {
      background-color: alpha(#${base}, 0.8);
      border-radius: 5px;
      color: #${text};
    }
    #match:selected {
      background-color: alpha(#${lavender}, 0.8);
      border-radius: 5px;
    }
    #window {
      background: none;
    }
  '';
in {
  imports = [ inputs.anyrun.homeManagerModules.anyrun ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        stdin
        symbols
        translate
        websearch
      ];
      width = { absolute = 800; };
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      hideIcons = false;
      hidePluginInfo = false;
      layer = "overlay";
      ignoreExclusiveZones = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
    };
    extraCss = style;
    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 10,
          terminal: Some("kitty"),
        )
      '';
      "cliphist/config.ron".text = ''
        Config(
          width: Absolute(800),
          x: Fraction(0.5),
          y: Fraction(0.3),
          layer: Overlay,
          hide_plugin_info: false,
          show_results_immediately: true,
          max_entries: Some(5),
          plugins: [
            "${
              inputs.anyrun-cliphist.packages.${pkgs.system}.default
            }/lib/libanyrun_cliphist.so"
          ],
        )
      '';
      "cliphist/cliphist.ron".text = ''
        Config(
          max_entries: 5,
          cliphist_path: "cliphist",
          prefix: "",
        )
      '';
      "cliphist/style.css".text = style;
    };
  };
}
