{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true; # For copilot and related tools
    withPython3 = true; # For python plugins

    # Making linters, formatters, and language servers available in the PATH for Neovim
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      nil # Nix language server
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted # html, css, json, eslint
      nodePackages."@tailwindcss/language-server"
      gopls
      rust-analyzer
      pyright
      ruff-lsp
      clang-tools # For clangd
      nodePackages.graphql-language-service-cli
      sqls
      glslang # For glsl_analyzer

      # Linters and formatters
      stylua # Lua formatter
      nixfmt-classic
      nodePackages.prettier
      nodePackages.eslint_d
      djlint
      rustywind
      shfmt
      gofumpt
      golines
      go-tools # For goimports
      sqlfluff
      mypy
      ruff
      nodePackages.sql-formatter
      vale
      hadolint
      shellcheck
      rustfmt
      clippy

      # For code actions
      impl # Go implementation generator
      gomodifytags

      # Debug adapters
      delve # Go debugger
      lldb # For codelldb

      # Dependencies
      fd # For telescope file finding
      gcc # For treesitter compilation
    ];
  };

  # Link the Neovim config to the home directory
  home.file.".config/nvim" = {
    source = ./dotfiles/nvim;
    recursive = true;
  };

}
