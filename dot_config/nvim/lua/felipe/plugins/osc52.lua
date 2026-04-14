local env = require("felipe.core.globals")

  -- Custom keymaps to yank to clipboard using osc52
return
  {
    'ojroques/nvim-osc52',
    cond = function()
      return env.isSSH
    end,

    config = function()
      require('osc52').setup()

      local has_clipboard = vim.fn.has 'clipboard' == 1
      local has_osc52 = pcall(require, 'osc52')

      local function copy_visual()
        if has_clipboard then
          vim.cmd 'normal! "+y'
        elseif has_osc52 then
          require('osc52').copy_visual()
        else
          vim.notify('No clipboard or OSC52 support found', vim.log.levels.ERROR)
        end
      end

      local function copy_normal()
        if has_clipboard then
          vim.cmd 'normal! "+yy'
        elseif has_osc52 then
          require('osc52').copy_register '"'
        else
          vim.notify('No clipboard or OSC52 support found', vim.log.levels.ERROR)
        end
      end

      vim.keymap.set('v', '<leader>c', copy_visual, { desc = '[C]opy selection to clipboard' })
      vim.keymap.set('n', '<leader>c', copy_normal, { desc = '[C]opy line to clipboard' })
    end,
  }
