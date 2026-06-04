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

	keys = {
		{ "<M-h>", ":TmuxNavigateLeft<cr>" },
		{ "<M-j>", ":TmuxNavigateDown<cr>" },
		{ "<M-k>", ":TmuxNavigateUp<cr>" },
		{ "<M-l>", ":TmuxNavigateRight<cr>" },
		{ "<M-\\>", ":TmuxNavigatePrevious<cr>" },
	},
}
