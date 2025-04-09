{ config, pkgs, ... }:

{
  home.username = "bogdan";
  home.homeDirectory = "/home/bogdan";

  home.packages = with pkgs; [
    ripgrep
    neovim
    tmux
    fish
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
