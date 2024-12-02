-- completion.lua
return {
    {
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            {
                'petertriho/cmp-git', config = function()
                    require('cmp_git').setup()
                end
            },
        },
    }
}
