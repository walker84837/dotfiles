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
    'walker84837/monotheme.nvim',
    'walker84837/gruber-darker.nvim',
    -- 'shaunsingh/solarized.nvim',
}
