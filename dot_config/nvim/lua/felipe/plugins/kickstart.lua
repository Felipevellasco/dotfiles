-- local env = require("felipe.core.globals")
-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
-- init.lua. If you want these files, they are in the repository, so you can just download them and
-- place them in the correct locations.

-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
--
--  Here are some example plugins that I've included in the Kickstart repository.
--  Uncomment any of the lines below to enable them (you will need to restart nvim).
--
return {
  -- NOTE: Plugins from kickstart repo moved to standard directory.
  -- {
  --   name = 'kickstart-autopairs',
  --
  --   -- Set enable condition
  --   cond = function()
  --     return not env.isMinimal
  --   end,
  --
  --   import = 'kickstart.plugins.autopairs',
  -- },
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
}
