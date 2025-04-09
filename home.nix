{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.username = "bogdan";
  home.homeDirectory = "/home/bogdan";

  home.stateVersion = "24.11";

  ## PACKAGES ##
  home.packages = with pkgs; [
    ripgrep
    neovim
    tmux
    fish
  ];

  ## ENV VARS ##
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  ## PROGRAMS ##
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    shellOptions = [ ];
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
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
  };

  programs.git = {
    enable = true;
    userName = "Bogdan Floris";
    userEmail = "bogdan.floris@gmail.com";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

}
