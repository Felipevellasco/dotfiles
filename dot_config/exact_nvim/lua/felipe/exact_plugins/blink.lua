local env = require("felipe.core.globals")

local function get_mini_icon(ctx)
	if ctx.source_name == "Path" then
		local is_unknown_type =
			vim.tbl_contains({ "link", "socket", "fifo", "char", "block", "unknown" }, ctx.item.data.type)
		local mini_icon, mini_hl, _ = require("mini.icons").get(
			is_unknown_type and "os" or ctx.item.data.type,
			is_unknown_type and "" or ctx.label
		)
		if mini_icon then
			return mini_icon, mini_hl
		end
	end
	local mini_icon, mini_hl, _ = require("mini.icons").get("lsp", ctx.kind)
	return mini_icon, mini_hl
end

return {
	-- Autocompletion
	"saghen/blink.cmp",

	-- Set enable condition
	cond = function()
		return not env.isCode
	end,

	event = "InsertEnter",
	version = "1.*",

	-- build = function()
	--   local ok, fuzzy = pcall(require, 'blink.cmp.fuzzy')
	--   if ok and fuzzy and fuzzy.build then
	--     fuzzy.build()
	--   else
	--     vim.notify('blink.cmp.fuzzy build failed', vim.log.leves.ERROR)
	--   end
	-- end,

	dependencies = {
		-- Snippet Engine
		{
			"L3MON4D3/LuaSnip",

			event = "VeryLazy",

			version = "2.*",
			build = (function()
				-- Build Step is needed for regex support in snippets.
				-- This step is not supported in many windows environments.
				-- Remove the below condition to re-enable on windows.
				-- if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
				-- return
				-- end
				return "make install_jsregexp"
			end)(),

			dependencies = {
				-- `friendly-snippets` contains a variety of premade snippets.
				--    See the README about individual language/framework/plugin snippets:
				--    https://github.com/rafamadriz/friendly-snippets
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
		"folke/lazydev.nvim",
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = {
			-- 'default' (recommended) for mappings similar to built-in completions
			--   <c-y> to accept ([y]es) the completion.
			--    This will auto-import if your LSP supports it.
			--    This will expand snippets if the LSP sent a snippet.
			-- 'super-tab' for tab to accept
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- For an understanding of why the 'default' preset is recommended,
			-- you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			--
			-- All presets have the following mappings:
			-- <tab>/<s-tab>: move to right/left of your snippet expansion
			-- <c-space>: Open menu or open docs if already open
			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
			-- <c-e>: Hide menu
			-- <c-k>: Toggle signature help
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			preset = "default",

			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-l>"] = { "select_and_accept", "snippet_forward", "fallback" },
			["<C-ç>"] = { "show", "hide", "fallback" },
			["<C-h>"] = { "show_documentation", "hide_documentation", "snippet_backward", "fallback" },

			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		completion = {
			-- By default, you may press `<c-space>` to show the documentation.
			-- Optionally, set `auto_show = true` to show the documentation after a delay.
			documentation = { auto_show = false, auto_show_delay_ms = 400 },
			ghost_text = { enabled = true, show_without_selection = true },

			list = { selection = {
				preselect = true,
				auto_insert = false,
			} },

			menu = {
				auto_show = true,
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								--- @diagnostic disable-next-line
								local kind_icon, kind_hl = get_mini_icon(ctx)
								return kind_icon
							end,
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl = get_mini_icon(ctx)
								return hl
							end,
						},
						kind = {
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl = get_mini_icon(ctx)
								return hl
							end,
						},
					},
				},
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "lazydev" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},

		snippets = { preset = "luasnip" },

		-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
		-- which automatically downloads a prebuilt binary when enabled.
		--
		-- By default, we use the Lua implementation instead, but you may enable
		-- the rust implementation via `'prefer_rust_with_warning'`
		--
		-- See :h blink-cmp-config-fuzzy for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },

		-- Shows a signature help window while you type arguments for a function
		signature = { enabled = true },

		cmdline = {

			keymap = {
				preset = "inherit",

				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-l>"] = { "select_and_accept", "fallback" },
				["<C-ç>"] = { "show", "hide", "fallback" },
			},

			completion = {
				menu = {
					--- @diagnostic disable-next-line
					auto_show = function(ctx)
						return vim.fn.getcmdtype() == ":"
					end,
				},

				ghost_text = { enabled = true }, -- Only works with Noice.nvim

				list = { selection = {
					preselect = true,
					auto_insert = false,
				} },
			},
		},
	},
}
