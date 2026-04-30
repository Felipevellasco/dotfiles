local felipe = require("felipe.core.globals")

-- NOTE: Custom autocommands
if not felipe.isMinimal and not felipe.isCode then
	-- Loads obsidian.nvim once a buffer is open inside an Obsidian vault
	vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
		pattern = { "*.md" },
		callback = function(args)
			-- Return if inside VS Code
			if felipe.isCode then
				return
			end

			require("lazy").load({ plugins = { "render-markdown.nvim" } })

			local workspace = vim.fs.normalize(vim.api.nvim_buf_get_name(args.buf))

			for _, entry in ipairs(felipe.obsidianVaults) do
				if workspace:find(vim.fs.normalize(entry.path)) then
					require("lazy").load({ plugins = { "obsidian.nvim" } })
					vim.notify("Obsidian vault detected: " .. entry.name, vim.log.levels.INFO)
					return
				end
			end
		end,
	})
end

-- WARN: Config commands below do not work as the .config folder is managed by chezmoi
-- Adds a command for quickly entering the Neovim configuration file
-- vim.api.nvim_create_user_command('Config', function()
-- vim.cmd('e ' .. vim.felipe.MYVIMRC)
-- end, {})
-- Adds a command to quickly reload the configuration file
-- vim.api.nvim_create_user_command('Reload', function()
-- vim.cmd('luafile ' .. vim.felipe.MYVIMRC)
-- end, {})

-- NOTE: Kickstart.nvim autocommands

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- The following two autocommands are used to highlight references of the
-- word under your cursor when your cursor rests there for a little while.
--    See `:help CursorHold` for information about when this is executed
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/documentHighlight", event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			-- When you move your cursor, the highlights will be cleared
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
	end,
})
