local felipe = require("felipe.core.globals")

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "3.x",
	lazy = false,

	cond = function()
		return not felipe.isCode
	end,

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},

	keys = {
		{ "<leader>e", ":Neotree reveal<CR>", desc = "[E]xplore files", silent = true },
	},
	opts = {
		filesystem = {
			window = {
				mappings = {
					["h"] = "navigate_up",
					["l"] = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						if node.type == "directory" then
							if not node:is_expanded() then
								require("neo-tree.sources.filesystem").toggle_directory(state, node, path)
							elseif node:has_children() then
								require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
							end
						end
						if node.type == "file" then
							require("neo-tree.utils").open_file(state, path)
							require("neo-tree.command").execute({ action = "close" })
						end
					end,

					["<leader>e"] = "close_window",
					-- ["<CR>"] = "open_and_close_neotree",
					-- ["<L>"] = "open_and_close_neotree",
					-- ["<S-CR>"] = "open",
					["<S-L>"] = "open",
				},
			},
		},

		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				-- event = "neo_tree_window_after_open",
				handler = function()
					vim.opt_local.number = true
					vim.opt_local.relativenumber = true
				end,
			},
		},
	},
}
