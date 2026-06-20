local felipe = require("felipe/core/globals")

return {
	"christoomey/vim-tmux-navigator",

	cond = function()
		return not felipe.isCode
	end,

	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
		"TmuxNavigatorProcessList",
	},

	-- Keys on felipe/core/keybindings.lua
	-- keys = {
	-- 	{ "<M-h>", ":TmuxNavigateLeft<cr>" },
	-- 	{ "<M-j>", ":TmuxNavigateDown<cr>" },
	-- 	{ "<M-k>", ":TmuxNavigateUp<cr>" },
	-- 	{ "<M-l>", ":TmuxNavigateRight<cr>" },
	-- 	{ "<M-\\>", ":TmuxNavigatePrevious<cr>" },
	-- },
}
