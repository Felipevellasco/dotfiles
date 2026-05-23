local felipe = require("felipe.core.globals")

local ghost_augroup = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", { clear = true })
local registerType = function(webPattern, filetype)
	vim.api.nvim_create_autocmd("User", {
		group = ghost_augroup,
		pattern = webPattern,
		command = ":set ft=" .. filetype,
		-- callback = function()
		-- 	vim.bo.filetype = "tex"
		-- end,
	})
end

return {
	"subnut/nvim-ghost.nvim",

	cond = function()
		return not felipe.isCode
	end,

	config = function()
		registerType("*prism.openai.com", "tex")
	end,

	keys = {
		{ "<leader>ug", ":GhostTextStart<cr>", desc = "Start [G]hostText server", silent = true },
	},
}
