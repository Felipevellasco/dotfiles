local env = require 'felipe.core.globals'

return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,

  -- ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = { 'BufReadPre ', 'BufNewFile' },
  -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  -- refer to `:h file-pattern` for more examples

  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    ui = { enable = false },
    workspaces = env.obsidianVaults,
  },
}
