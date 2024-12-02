-- core.lua
return {
    {
        'editorconfig/editorconfig-vim',
        event = 'BufRead',  -- Load when a buffer is read
    },
    {
        'tpope/vim-commentary',
        event = 'InsertEnter',  -- Load when entering insert mode
    },
    {
        'tpope/vim-surround',
        event = 'InsertEnter',  -- Load when entering insert mode
    }
}
