local env = require("felipe.core.globals")

return {
  'NMAC427/guess-indent.nvim',

  -- Set enable condition
  cond = function()
    return not env.isMinimal
  end,

  config = function()
    require('guess-indent').setup {
      auto_cmd = true, -- Detect tabstop and shiftwidth automatically
      override_editorconfig = false, -- Prevent overrides from .editorconfig files
      -- filetype_exclude = {},
      -- buftype_exclude = {},
    }
  end,
}
