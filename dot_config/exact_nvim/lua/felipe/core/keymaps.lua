local env = require 'felipe.core.globals'
local helpers = require 'felipe.core.helpers'

-- Clipboard integration
helpers.nmap('\\yy', helpers.nCopy, { desc = '[Y]ank to clipboard' })
helpers.vmap('\\y', helpers.vCopy, { desc = '[Y]ank selection to clipboard' })

-- Esc remapping
helpers.imap('jk', '<Esc>', { desc = 'Return to normal mode', silent = true })

-- Explorer call
helpers.nmap('<leader>e', helpers.explorer, { desc = '[E]xplore files' })
helpers.nmap('<leader>E', helpers.Explorer, { desc = '[E]xplore files (keep open)' })

-- Tab navigation
helpers.nmap('<leader>]', 'gt', { desc = 'Next tab' })
helpers.nmap('<leader>[', 'gT', { desc = 'Previous tab' })

-- NOTE: Kickstart keymaps
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
--
-- NOTE: LSP Keymaps (Kickstart)
--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
	-- NOTE: Remember that Lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local map = function(keys, func, desc, mode)
	  mode = mode or 'n'
	  vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
	end

	-- Rename the variable under your cursor.
	--  Most Language Servers support renaming across files, etc.
	map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

	-- Execute a code action, usually your cursor needs to be on top of an error
	-- or a suggestion from your LSP for this to activate.
	map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

	-- Find references for the word under your cursor.
	map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

	-- Jump to the implementation of the word under your cursor.
	--  Useful when your language has ways of declaring types without an actual implementation.
	map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

	-- Jump to the definition of the word under your cursor.
	--  This is where a variable was first declared, or where a function is defined, etc.
	--  To jump back, press <C-t>.
	map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

	-- WARN: This is not Goto Definition, this is Goto Declaration.
	--  For example, in C this would take you to the header.
	map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

	-- Fuzzy find all the symbols in your current document.
	--  Symbols are things like variables, functions, types, etc.
	map('gO', require('telescope.builtin').lsp_document_symbols, '[O]pen Document Symbols')

	-- Fuzzy find all the symbols in your current workspace.
	--  Similar to document symbols, except searches over your entire project.
	map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open [W]orkspace Symbols')

	-- Jump to the type of the word under your cursor.
	--  Useful when you're not sure what type a variable is and you want to see
	--  the definition of its *type*, not where it was *defined*.
	map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

	-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
	---@param client vim.lsp.Client
	---@param method vim.lsp.protocol.Method
	---@param bufnr? integer some lsp support methods only in specific files
	---@return boolean
	local function client_supports_method(client, method, bufnr)
	  if vim.fn.has 'nvim-0.11' == 1 then
		return client:supports_method(method, bufnr)
	  else
		return client.supports_method(method, { bufnr = bufnr })
	  end
	end

	-- The following two autocommands are used to highlight references of the
	-- word under your cursor when your cursor rests there for a little while.
	--    See `:help CursorHold` for information about when this is executed
	--
	-- When you move your cursor, the highlights will be cleared (the second autocommand).
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
	  local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
	  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
		buffer = event.buf,
		group = highlight_augroup,
		callback = vim.lsp.buf.document_highlight,
	  })

	  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
		buffer = event.buf,
		group = highlight_augroup,
		callback = vim.lsp.buf.clear_references,
	  })

	  vim.api.nvim_create_autocmd('LspDetach', {
		group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
		callback = function(event2)
		  vim.lsp.buf.clear_references()
		  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
		end,
	  })
	end

	-- The following code creates a keymap to toggle inlay hints in your
	-- code, if the language server you are using supports them
	--
	-- This may be unwanted, since they displace some of your code
	if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
	  map('<leader>th', function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
	  end, '[T]oggle Inlay [H]ints')
	end
  end,
})
