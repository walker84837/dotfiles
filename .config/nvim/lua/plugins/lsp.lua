-- lsp.lua
return {
    'neovim/nvim-lspconfig',
    'Decodetalkers/csharpls-extended-lsp.nvim',
    'rust-lang/rust.vim',
    'ziglang/zig.vim',
    'heavenshell/vim-jsdoc',
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            vim.cmd('TSEnable highlight')
        end
    },
    'fatih/vim-go',
    'wstucco/c3.nvim',
    { 'Exafunction/codeium.vim', branch = 'main' },
}
