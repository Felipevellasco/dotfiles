return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      'çs',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = '[S]earch with Flash',
    },
    {
      'çS',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = '[S]earch with Flash Treesitter',
    },
    {
      'çr',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = '[R]emote Flash',
    },
    {
      'çR',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = '[R]emote Treesitter Search',
    },
    {
      '<c-s>',
      mode = { 'c' },
      function()
        require('flash').toggle()
      end,
      desc = 'Toggle Flash Search',
    },
  },
}
