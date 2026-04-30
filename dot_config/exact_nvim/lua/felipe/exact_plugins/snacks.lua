local felipe = require("felipe.core.globals")

local function colorscript()
	if felipe.isWin then
		return "/c/users/felipe/.colorscripts/colorscript.sh -e square"
	else
		return "colorscript -e square"
	end
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	cond = function()
		return not felipe.isCode
	end,

	opts = {
		dashboard = {
			width = 60,
			row = nil, -- dashboard position. nil for center
			col = nil, -- dashboard position. nil for center
			pane_gap = 4, -- empty columns between vertical panes
			autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence

			-- These settings are used by some built-in sections
			preset = {
				-- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
				pick = nil,

				-- Used by the `keys` section to show keymaps.
				-- Set your custom keymaps here.
				-- When using a function, the `items` argument are the default keymaps.
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},

				-- Used by the `header` section
				header = [[
      ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
      ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
      ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
			},

			-- item field formatters
			formats = {
				icon = function(item)
					if item.file and item.icon == "file" or item.icon == "directory" then
						--- @diagnostic disable-next-line
						return Snacks.dashboard.icon(item.file, item.icon)
					end
					return { item.icon, width = 2, hl = "icon" }
				end,
				footer = { "%s", align = "center" },
				header = { "%s", align = "center" },
				file = function(item, ctx)
					local fname = vim.fn.fnamemodify(item.file, ":~")
					fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
					if #fname > ctx.width then
						local dir = vim.fn.fnamemodify(fname, ":h")
						local file = vim.fn.fnamemodify(fname, ":t")
						if dir and file then
							file = file:sub(-(ctx.width - #dir - 2))
							fname = dir .. "/…" .. file
						end
					end
					local dir, file = fname:match("^(.*)/(.+)$")
					return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
				end,
			},
			sections = {
				{ section = "header" },

				{
					pane = 2,
					section = "terminal",
					-- On Windows, installing this command requires modifying the script with the correct DIR_COLORSCRIPTS directory. This can be done using a shell variable.
					-- The command must also be patched so that it runs correctly.
					cmd = colorscript(),
					height = 5,
					padding = 1,
				},

				{ section = "keys", gap = 1, padding = 1 },

				{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },

				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },

				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						--- @diagnostic disable-next-line
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},

				{ section = "startup" },
			},
		},

		bigfile = { enabled = true },

		explorer = {
			enabled = false,
			replace_netrw = true,
			trash = true,
		},

		indent = { enabled = true },

		input = { enabled = true },

		image = { enabled = true },

		picker = {
			enabled = true,
			-- sources = {
			-- 	explorer = {
			-- 		auto_close = true,
			-- 		layout = {
			-- 			preset = "sidebar",
			-- 			preview = false,
			-- 			layout = { position = "left" },
			-- 		},
			-- 	},
			-- },
		},

		notifier = { enabled = true, timeout = 5000 },

		lazygit = { enabled = true, preview = false },

		quickfile = { enabled = true },

		scope = { enabled = true },

		scroll = {
			enabled = true,

			animate = {
				duration = { step = 10, total = 150 },
				easing = "linear",
			},
			-- faster animation when repeating scroll after delay
			animate_repeat = {
				delay = 100, -- delay in ms before using the repeat animation
				duration = { step = 5, total = 50 },
				easing = "linear",
			},
			-- what buffers to animate
			filter = function(buf)
				return vim.g.snacks_scroll ~= false
					and vim.b[buf].snacks_scroll ~= false
					and vim.bo[buf].buftype ~= "terminal"
			end,
		},

		statuscolumn = { enabled = true },

		words = { enabled = true },
	},

	keys = {
		{
			"<leader>dn",
			function()
				Snacks.notifier.hide()
			end,
			desc = "[D]ismiss [N]otifications",
		},

		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "[N]otification history",
		},

		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "[G]it [B]ranches",
		},

		{
			"<leader>gl",
			function()
				Snacks.lazygit.log({ preview = false })
			end,
			desc = "[G]it [L]og",
		},

		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "[G]it [L]og (line)",
		},

		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "[G]it [S]tatus",
		},

		-- {
		--   '<leader>gS',
		--   function()
		--     Snacks.picker.git_stash()
		--   end,
		--   desc = 'Git Stash',
		-- },

		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "[G]it [D]iff (Hunks)",
		},

		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "[G]it Log [F]ile",
		},
	},
}
