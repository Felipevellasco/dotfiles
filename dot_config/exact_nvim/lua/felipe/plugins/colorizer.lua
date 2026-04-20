return {
    'catgoose/nvim-colorizer.lua',
    -- #FF2350

    event = "BufReadPre",

    config = function()
        require('colorizer').setup({
            filetypes = {'*'},
            options = {
                parsers = {
                    names = {
                        enable = false,
                    },
                    rgb = { enable = true },
                    hsl = { enable = true },
                    xterm = { enable = true },
                },
            },
        })

        -- vim.api.nvim_create_autocmd({'BufEnter'}, {
        -- callback = function()
            -- require('colorizer').
        -- end
        -- })
    end,
}
