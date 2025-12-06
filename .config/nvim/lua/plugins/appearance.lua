-- appearance.lua
return {
    'nvim-lualine/lualine.nvim',
    -- Colorscheme
    {
        lazy = false,
        priority = 1000,
        'catppuccin/nvim', as = 'catppuccin',
    },
    -- Other colorschemes
    'walker84837/monotheme.nvim',
    'walker84837/gruber-darker.nvim',
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end,
    }
}
