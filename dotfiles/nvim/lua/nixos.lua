-- This file is used to provide configuration specific to NixOS
-- It provides information about what LSP servers and tools are available through NixOS
local M = {}

-- These are LSP servers available through NixOS packages
M.available_servers = {
	"lua_ls",
	"nil_ls",
	"tsserver",
	"eslint",
	"html",
	"cssls",
	"jsonls",
	"tailwindcss",
	"gopls",
	"rust_analyzer",
	"zls",
	"pyright",
	"ruff_lsp",
	"clangd",
	"graphql",
	"sqls",
	"glsl_analyzer",
}

-- Formatters and linters available through NixOS
M.formatters = {
	"stylua",
	"prettier",
	"eslint_d",
	"djlint",
	"rustywind",
	"shfmt",
	"gofumpt",
	"goimports",
	"golines",
	"sqlfluff",
	"clang-format",
	"mypy",
	"ruff",
	"sqlfluff",
	"vale",
	"hadolint",
	"shellcheck",
	"rustfmt",
	"nixfmt",
}

-- Debug adapters available through NixOS
M.debug_adapters = {
	"delve", -- Go debugger
	"codelldb", -- C/C++/Rust debugger
}

return M
