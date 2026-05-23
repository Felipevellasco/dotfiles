local felipe = require("felipe.core.globals")

return {
	"lervag/vimtex",
	lazy = false,

	cond = function()
		return not felipe.isCode
	end,

	init = function() end,
}
