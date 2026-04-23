local felipe = require("felipe.core.globals")
-- Highlight, edit, and navigate code
return {
	"nvim-treesitter/nvim-treesitter",

	branch = "main", -- Ensure compatibility with Neovim 0.12

	-- Set enable condition
	cond = function()
		return not felipe.isMinimal
	end,

	build = ":TSUpdate",
	main = "nvim-treesitter", -- Sets main module to use for opts
	-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
	opts = {
		-- Autoinstall languages that are not installed
		auto_install = true,
		-- highlight = {
		-- 	enable = true,
		-- 	-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
		-- 	--  If you are experiencing weird indenting issues, add the language to
		-- 	--  the list of additional_vim_regex_highlighting and disabled languages for indent.
		-- 	additional_vim_regex_highlighting = { "ruby" },
		-- },
		indent = { enable = true, disable = { "ruby" } },
	},
	-- There are additional nvim-treesitter modules that you can use to interact
	-- with nvim-treesitter. You should go explore a few and see what interests you:
	--
	--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
	--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
	--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
	},

	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				-- Enable treesitter highlighting and disable regex syntax
				pcall(vim.treesitter.start)
				-- Enable treesitter-based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

				-- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				-- vim.wo[0][0].foldmethod = "expr"
			end,
		})

		-- Install parsers
		local alreadyInstalled = require("nvim-treesitter.config").get_installed()
		local parsersToInstall = vim.iter(felipe.treesitterEnsureInstalled)
			:filter(function(parser)
				return not vim.tbl_contains(alreadyInstalled, parser)
			end)
			:totable()
		require("nvim-treesitter").install(parsersToInstall)
	end,
}
