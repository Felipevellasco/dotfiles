local env = require 'felipe.core.globals'

return {
  {
    'MeanderingProgrammer/render-markdown.nvim',

    lazy = true,
    ft = 'markdown',
    event = { 'BufReadPre', 'BufNew' },

    -- cond = function()
    --   local cwd = vim.fn.getcwd()
    --   return not cwd:find 'Obsidian'
    -- end,

    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins

    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons

    opts = {},
  },
}
