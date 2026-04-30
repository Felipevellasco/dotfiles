local env = require 'felipe.core.globals'
local M = {}

-- Copy lambdas: set copy to use osc52 if no clipboard is detected
M.vCopy = (env.isSSH or not env.clipboard) and function()
  require('osc52').copy_visual()
end or function()
  vim.cmd 'normal! "+y'
end

-- Copy operator lambda
M.nCopy = (env.isSSH or not env.clipboard) and function()
  require('osc52').copy()
end or function()
  vim.cmd 'normal! "+yy'
end

-- File explorer lambda
local explorerHandler = function(keepOpen)
  keepOpen = keepOpen or false

  local snacks = require 'snacks'
  local explorers = snacks.picker.get { source = 'explorer' }
  local explorer = explorers[1]

  if not explorer or explorer.closed then
    -- Not open: open and reveal current file
    snacks.explorer.reveal()
    snacks.explorer.auto_close = not keepOpen
    return
  end

  if not explorer:is_focused() then
    -- Open but not focused: focus without revealing
    explorer:focus()
    return
  end

  -- Open and focused
  if not keepOpen then
    vim.cmd 'wincmd q'
  else
    vim.cmd 'wincmd p'
  end
end

M.explorer = function()
	explorerHandler(false)
end

M.Explorer = function()
	explorerHandler(true)
end

-- Mapping helpers
M.map = function(mode, keys, action, options)
  vim.keymap.set(mode, keys, action, options)
end

M.nmap = function(keys, action, options)
  M.map('n', keys, action, options)
end

M.vmap = function(keys, action, options)
  M.map('v', keys, action, options)
end

M.imap = function(keys, action, options)
  M.map('i', keys, action, options)
end

return M
