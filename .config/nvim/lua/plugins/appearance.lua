-- appearance.lua
return {
-- Colorscheme
    'nvim-lualine/lualine.nvim',
    {
        lazy = false,
        priority = 1000,
        'catppuccin/nvim', as = 'catppuccin',
        config = function()
            vim.cmd('colorscheme catppuccin-mocha')
        end,
    },
    -- 'shaunsingh/nord.nvim',
    -- 'shaunsingh/solarized.nvim',
    -- 'walker84837/gruber-darker.vim',
}
