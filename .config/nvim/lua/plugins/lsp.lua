-- lsp.lua
return {
    'neovim/nvim-lspconfig',
    {
        "seblyng/roslyn.nvim",
        ---@module 'roslyn.config'
        opts = {

        },
    },
    'rust-lang/rust.vim',
    'ziglang/zig.vim',
    'heavenshell/vim-jsdoc',
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        'scalameta/nvim-metals',
        ft = { 'scala', 'sbt' },
    },
    'fatih/vim-go',
    'wstucco/c3.nvim',
    { 'Exafunction/codeium.vim', event = 'BufEnter' }
}
