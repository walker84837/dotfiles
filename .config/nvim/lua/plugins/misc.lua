-- misc.lua
return {
    {
        'alx741/vinfo',
        event = 'VeryLazy',
	    lazy = true
    },
    'andweeb/presence.nvim',
    {
        'walker84837/ripgrep.nvim',
        config = function()
            require('ripgrep')
        end
    }
}
