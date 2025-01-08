{ lib, config, ... }: {
  options.dotfiles = with lib; {
    repo = mkOption {
      description = "Location of dotfiles repo";
      type = types.str;
      default = "${config.home.homeDirectory}/dotfiles";
    };
    linkDots = mkOption {
      description = "Function to link entries from dotfiles repo";
      readOnly = true;
    };
    links = mkOption {
      description = "List of entries to link to XDG_CONFIG_HOME";
      type = types.listOf types.str;
      default = [];
    };
  };

  config.dotfiles.linkDots = (name: {
    enable = true;
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repo}/${name}";
    target = "${name}";
  });

  config.xdg.configFile = builtins.listToAttrs
    (lib.lists.forEach config.dotfiles.links
      (v: { name = v; value = config.dotfiles.linkDots v; }));
}
