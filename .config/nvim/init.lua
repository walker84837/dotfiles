require("config.lazy")

-- init.lua
require('lazy').setup("plugins")

-- Basic settings
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.incsearch = true
vim.opt.mouse = ""
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.showmatch = true
vim.opt.showcmd = true

-- Key bindings
vim.api.nvim_set_keymap('n', '<S-Down>', ':m .+1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Up>', ':m .-2<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-F>', ':%!rustfmt --edition 2021<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-d>', ':%!cmark -t commonmark --width 80<CR>', { noremap = true, silent = true })

-- Plugin options
vim.g.markdown_fenced_languages = { 'rust', 'toml', 'cpp', 'c', 'html', 'python', 'bash=sh' }
vim.g.rustfmt_autosave = 1
vim.g.NeoTreeRefreshToggleHidden = 1

vim.api.nvim_create_user_command('Rg', function(opts)
    local query = opts.args
    local tempfile = vim.fn.tempname()  -- Create a temporary file

    -- Execute the rg command and capture its output
    local command = 'rg -i --vimgrep ' .. vim.fn.shellescape(query)
    local handle = io.popen(command)
    if not handle then
        print("Failed to execute command: " .. command)
        return
    end
    local output = handle:read('*a')
    handle:close()

    -- Check if output is empty
    if output == '' then
        print("No results found for query: " .. query)
        return
    end

    -- Write output to the temporary file
    local file = io.open(tempfile, 'w')
    if file then
        file:write(output)
        file:close()
    else
        print("Failed to write to file: " .. tempfile)
        return
    end

    -- Load the results into the quickfix list
    vim.cmd('silent! cgetfile ' .. tempfile)
    
    -- Open the quickfix window
    vim.cmd('copen')
    
    -- Clean up the temporary file
    vim.fn.delete(tempfile)
end, { nargs = 1 })

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}


require("cmp").setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})
require("cmp_git").setup()

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")
local on_attach = function(client)
    require("completion").on_attach(client)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

lspconfig.clangd.setup({ capabilities = capabilities })
lspconfig.gopls.setup({ capabilities = capabilities })
lspconfig.bashls.setup({ capabilities = capabilities })
lspconfig.java_language_server.setup({ capabilities = capabilities })
lspconfig.csharp_ls.setup({ capabilities = capabilities })

lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    root_dir = lspconfig.util.root_pattern("Cargo.toml"),
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
})

require("presence").setup({
    neovim_image_text   = "i use neovim btw",
})