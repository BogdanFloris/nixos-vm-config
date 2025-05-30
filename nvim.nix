{ pkgs, unstablePkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = unstablePkgs.neovim-unwrapped;
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
      unstablePkgs.nodePackages.typescript-language-server
      unstablePkgs.nodePackages.vscode-langservers-extracted # html, css, json, eslint
      nodePackages."@tailwindcss/language-server"
      gopls
      rust-analyzer
      pyright
      basedpyright
      ruff
      clang-tools # For clangd
      nodePackages.graphql-language-service-cli
      sqls
      htmx-lsp
      glslang # For glsl_analyzer
      unstablePkgs.copilot-language-server-fhs

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
      ruff
      nodePackages.sql-formatter
      hadolint
      shellcheck
      rustfmt
      clippy
      nixfmt-classic

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
