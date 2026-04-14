local env = require 'felipe.core.globals'

-- Loads obsidian.nvim once a buffer is open inside an Obsidian vault
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  pattern = { '*.md' },
  callback = function(args)
    -- Return if inside VS Code
    if env.isCode then
      return
    end

    require('lazy').load { plugins = { 'render-markdown.nvim' } }

    local workspace = vim.fs.normalize(vim.api.nvim_buf_get_name(args.buf))

    for _, entry in ipairs(env.obsidianVaults) do
      if workspace:find(vim.fs.normalize(entry.path)) then
        require('lazy').load { plugins = { 'obsidian.nvim' } }
        vim.notify('Obsidian vault detected: ' .. entry.name, vim.log.levels.INFO)
        return
      end
    end
  end,
})
