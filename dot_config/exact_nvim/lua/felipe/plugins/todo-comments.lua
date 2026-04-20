local env = require("felipe.core.globals")
-- Highlight todo, notes, etc in comments

return
  {
    'folke/todo-comments.nvim',

    -- Set enable condition
    cond = function()
      return not env.isCode
    end,

    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  }
