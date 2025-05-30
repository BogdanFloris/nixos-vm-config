{ config, lib, pkgs, unstablePkgs, ... }:

{
  imports = [ ./nvim.nix ];

  home.username = "bogdan";
  home.homeDirectory = "/home/bogdan";

  home.stateVersion = "25.05";

  ## PACKAGES ##
  home.packages = with pkgs; [
    ripgrep
    tmux
    fish
    fishPlugins.autopair
    fishPlugins.fzf-fish
    fishPlugins.fish-you-should-use
    fishPlugins.plugin-git
    fishPlugins.hydro
    fishPlugins.sponge
    fishPlugins.colored-man-pages
    bat
    sesh
    zoxide
    atuin
    lazygit
    lazydocker
    nodejs
    yarn
    python3
    cargo
    unzip
    ghostty
    chromium
    postgresql
    teleport
    k9s
    kubectl
    jfrog-cli
    jq
    awscli2
    jujutsu

    unstablePkgs.aider-chat
    unstablePkgs.claude-code
    unstablePkgs.httpyac
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yml;
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
    secrets = {
      npm_token = { path = "${config.sops.defaultSymlinkPath}/npm_token"; };
      anthropic_api_key = {
        path = "${config.sops.defaultSymlinkPath}/anthropic_api_key";
      };
      gemini_api_key = {
        path = "${config.sops.defaultSymlinkPath}/gemini_api_key";
      };
    };

  };

  ## ENV VARS ##
  home.sessionVariables = { };

  ## PROGRAMS ##
  programs.home-manager.enable = true;

  # Add i3 config management
  home.file.".config/i3/config" = { source = ./dotfiles/i3.conf; };

  # Ghostty config
  home.file.".config/ghostty/config" = { source = ./dotfiles/ghostty/config; };

  # npmrc
  home.file.".npmrc" = {
    source = ./dotfiles/npmrc;
    executable = false;
  };

  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };
  };

  programs.bash = {
    enable = true;
    shellOptions = [ ];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = ''
      # If we're running interactively (not via script, ssh command etc.)
      # and fish exists, replace bash with fish.
      # Check SHLVL to avoid doing this in sub-shells.
      if [[ $- == *i* && -x "$(command -v fish)" && "$SHLVL" -le 1 ]]; then
        exec fish
      fi
    '';
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "fish-you-should-use";
        src = pkgs.fishPlugins.fish-you-should-use.src;
      }
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
    ];

    shellAliases = {
      lg = "lazygit";
      ld = "lazydocker";
    };

    functions = {
      fish_user_key_bindings = ''
        # Use Cmd+Space to accept autosuggestion
        bind -k nul forward-char
      '';
    };

    interactiveShellInit = ''
      export NPM_TOKEN=$(cat ${config.sops.secrets.npm_token.path})
      export ANTHROPIC_API_KEY=$(cat ${config.sops.secrets.anthropic_api_key.path})
      export GEMINI_API_KEY=$(cat ${config.sops.secrets.gemini_api_key.path})
    '';
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
      color = "always";
      style = "changes,numbers";
    };
  };

  programs.git = {
    enable = true;
    userName = "Bogdan Floris";
    userEmail = "bogdan.floris@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      column.ui = "auto";
      branch.date = "-commiterdate";
      tag.sort = "version:refname";
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      help.autocorrect = "prompt";
      commit.verbose = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    secureSocket = false;
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = lib.strings.concatStrings (lib.strings.intersperse "\n"
      ([ (builtins.readFile ./dotfiles/tmux.conf) ]));
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    defaultCacheTtlSsh = 604800;
    maxCacheTtlSsh = 604800;
    enableSshSupport = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  xresources.extraConfig = builtins.readFile ./dotfiles/Xresources;

  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
