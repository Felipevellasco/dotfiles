local env = require 'felipe.core.globals'

-- Collection of various small independent plugins/modules
return {
  'echasnovski/mini.nvim',

  -- Set enable condition
  cond = function()
    return not env.isCode
  end,

  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Commenting aid
    require('mini.comment').setup()

    -- Session management
    require('mini.sessions').setup()

    -- Indents the working scope
    -- Swapped by snacks.nvim
    -- require('mini.indentscope').setup {
    --   draw = {
    --     -- Changes the animation style
    --     animation = require('mini.indentscope').gen_animation.exponential {
    --       easing = 'out',
    --       duration = 300,
    --       unit = 'total',
    --       -- Unit = total makes the animation better no matter the size of the indent
    --       -- duration = 20,
    --       -- unit = 'step',
    --     },
    --     -- Can be completely disabled if desired:
    --     -- animation = require('mini.indentscope').gen_animation.none()
    --   },
    -- }
    --
    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
