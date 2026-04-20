local felipe = require 'felipe.core.globals'

-- NOTE: Custom autocommands

-- Loads obsidian.nvim once a buffer is open inside an Obsidian vault
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  pattern = { '*.md' },
  callback = function(args)
    -- Return if inside VS Code
    if felipe.isCode then
      return
    end

    require('lazy').load { plugins = { 'render-markdown.nvim' } }

    local workspace = vim.fs.normalize(vim.api.nvim_buf_get_name(args.buf))

    for _, entry in ipairs(felipe.obsidianVaults) do
      if workspace:find(vim.fs.normalize(entry.path)) then
        require('lazy').load { plugins = { 'obsidian.nvim' } }
        vim.notify('Obsidian vault detected: ' .. entry.name, vim.log.levels.INFO)
        return
      end
    end
  end,
})

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
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
