-- appearance.lua
return {
    'nvim-lualine/lualine.nvim',
    -- Colorscheme
    {
        lazy = false,
        priority = 1000,
        'catppuccin/nvim', as = 'catppuccin',
        config = function()
            vim.cmd('colorscheme catppuccin-mocha')
        end,
    },
    -- Other colorschemes
    -- 'shaunsingh/nord.nvim',
    -- 'shaunsingh/solarized.nvim',
    -- 'walker84837/gruber-darker.vim',
}
