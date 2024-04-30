{ lib, pkgs, ... }: {
  home.packages = with pkgs; [ wl-clipboard gcc nixfmt ];

  home.sessionVariables = {
    XCURSOR_SIZE = 32;
    QT_QPA_PLATFORM = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  programs.git = {
    enable = true;
    userName = "AsriFox";
    userEmail = "asrifox@yandex.ru";
    extraConfig = { credential = { helper = "store"; }; };
  };

  programs.fish = {
    enable = true;
    functions = {
      cat = "bat --paging never --style plain $argv";
      less = "bat --paging always $argv";
    };
  };

  programs.bat = {
    enable = true;
    config = { pager = "${pkgs.less}/bin/less -FR"; };
  };

  programs.lazygit.enable = true;

  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      background_opacity = lib.mkForce "0.9";
      shell = "fish";
      editor = "nvim";
      clipboard_max_size = "64";
    };
  };

  services.cliphist.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings = {
      format =
        "$username$hostname$directory$cmd_duration$line_break$python$character";
      right_format = "$git_branch$git_state$git_status";
      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      directory = {
        truncation_length = 4;
        style = "bold lavender";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "surface2";
      };
      git_status = {
        format =
          "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "teal";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "surface1";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      python = {
        format = "[$virtualenv]($style) ";
        style = "surface2";
      };
    };
  };
}

