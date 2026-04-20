local felipe = require("felipe.core.globals")

return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",

	-- Set enable condition
	cond = function()
		return not felipe.isCode
	end,

	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		-- Mason must be loaded before its dependents so we need to set it up here.
		-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by blink.cmp
		"saghen/blink.cmp",
	},
	config = function()
		-- Brief aside: **What is LSP?**
		--
		-- LSP is an initialism you've probably heard, but might not understand what it is.
		--
		-- LSP stands for Language Server Protocol. It's a protocol that helps editors
		-- and language tooling communicate in a standardized fashion.
		--
		-- In general, you have a "server" which is some tool built to understand a particular
		-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
		-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
		-- processes that communicate with some "client" - in this case, Neovim!
		--
		-- LSP provides Neovim with features like:
		--  - Go to definition
		--  - Find references
		--  - Autocompletion
		--  - Symbol Search
		--  - and more!
		--
		-- Thus, Language Servers are external tools that must be installed separately from
		-- Neovim. This is where `mason` and related plugins come into play.
		--
		-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
		-- and elegantly composed help section, `:help lsp-vs-treesitter`

		-- Diagnostic Config
		-- See :help vim.diagnostic.Opts
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = "󱈸 ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = "󰌵 ",

					-- [vim.diagnostic.severity.ERROR] = ' ',
					-- [vim.diagnostic.severity.WARN] = ' ',
					-- [vim.diagnostic.severity.HINT] = '󰌶 ',
					-- [vim.diagnostic.severity.INFO] = ' ',
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				prefix = "●",
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

		local servers = {
			"clangd",
			"pyright",
			"lua_ls",
			"buf_ls",
			"texlab",
			-- 'rust_analyzer',
			-- 'asm_lsp',
		}

		-- TODO: old Kickstart code, remove once new code is tested
		-- local servers = {
		--   clangd = {
		--     cmd = { 'clangd', '--compile-commands-dir=.' },
		--     settings = {
		--       diagnostics = { disable = { '-mlongcalls' } },
		--     },
		--   },
		--   -- asm_lsp = {},
		--   buf_ls = {},
		--   pyright = {},
		--   -- gopls = {},
		--   -- rust_analyzer = {},
		--   -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
		--   --
		--   -- Some languages (like typescript) have entire language plugins that can be useful:
		--   --    https://github.com/pmizio/typescript-tools.nvim
		--   --
		--   -- But for many setups, the LSP (`ts_ls`) will work just fine
		--   -- ts_ls = {},
		--   --
		--
		--   lua_ls = {
		--     -- cmd = { ... },
		--     -- filetypes = { ... },
		--     -- capabilities = {},
		--     settings = {
		--       Lua = {
		--         completion = {
		--           callSnippet = 'Replace',
		--         },
		--         diagnostics = {
		--           globals = { 'vim' },
		--           -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
		--           -- disable = { 'missing-fields' },
		--         },
		--       },
		--     },
		--   },
		-- }
		--

		-- Ensure the servers and tools above are installed
		--
		-- To check the current status of installed tools and/or manually install
		-- other tools, you can run
		--    :Mason
		--
		-- You can press `g?` for help in this menu.
		--
		-- `mason` had to be setup earlier: to configure its options see the
		-- `dependencies` table for `nvim-lspconfig` above.
		--
		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.

		local ensure_installed = servers or {}
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
			automatic_enable = {
				exclude = { "ts_ls" },
			},
			handlers = {
				function(server_name)
					-- TODO: old Kickstart code, remove once new code is tested
					-- local server = servers[server_name] or {}
					-- -- This handles overriding only values explicitly passed
					-- -- by the server configuration above. Useful when disabling
					-- -- certain features of an LSP (for example, turning off formatting for ts_ls)
					-- server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
					-- vim.lsp.config(server_name, server)

					local server = {}
					local has_override, override_config = pcall(require, "felipe.lsp.overrides." .. server_name)
					if has_override then
						server = override_config
					end

					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					vim.lsp.config(server_name, server)
				end,
			},
		})
	end,
}
