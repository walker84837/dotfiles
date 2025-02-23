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

-- Move lines
vim.api.nvim_set_keymap('n', '<S-Down>', ':m .+1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Up>', ':m .-2<CR>', { noremap = true, silent = true })

-- Open file browsers
vim.api.nvim_set_keymap('n', "<Leader>f", ":Neotree right<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<Leader>s", ":Telescope find_files<CR>", { noremap = true, silent = true })

-- Plugin options
vim.g.markdown_fenced_languages = { 'rust', 'toml', 'cpp', 'c', 'html', 'python', 'bash=sh' }
vim.g.rustfmt_autosave = 1
vim.g.NeoTreeRefreshToggleHidden = 1

local cmp = require("cmp")
local luasnip = require('luasnip')
local lualine = require('lualine')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")

-- Create augroup for resetting indentation
vim.api.nvim_create_augroup("lua_indent", { clear = true })

-- Set indentation for languages
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"c", "cpp", "cs", "java", "lua"},
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
    end,
})

-- Set indentation for hyprlang
vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

lualine.setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
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
        lualine_b = {'branch', 'diff', 'fileformat'},
        lualine_c = {'filename'},
        lualine_x = {'diagnostics'},
        lualine_y = {'encoding', 'filetype'},
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

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
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

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

local on_attach = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ async = false })
        end
    })
end

lspconfig.clangd.setup({ capabilities = capabilities })
lspconfig.gopls.setup({ capabilities = capabilities })
lspconfig.bashls.setup({ capabilities = capabilities })
lspconfig.jdtls.setup({ capabilities = capabilities })
lspconfig.omnisharp.setup({
    cmd = { "/usr/bin/omnisharp", "--languageserver" },
    on_attach = on_attach,
    capabilities = capabilities
})
lspconfig.metals.setup({ capabilities = capabilities })
lspconfig.lua_ls.setup({
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        })
    end,
    capabilities = capabilities,
    settings = {
        Lua = {}
    }
})

lspconfig.kotlin_language_server.setup({
    filetypes = {"kotlin", "kt"}
})

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

local function ignore_rust_analyzer_errors()
    -- Store the original notify function
    local original_notify = vim.notify

    -- Override the vim.notify function
    vim.notify = function(msg, ...)
        if msg:find("rust_analyzer: ") then
            return
        end
        -- Call the original notify function for other messages
        original_notify(msg, ...)
    end

    -- Store the original window/showMessage handler
    local original_showMessage = vim.lsp.handlers["window/showMessage"]

    -- Override the window/showMessage handler
    vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
        if result and result.message and result.message:find("rust_analyzer: ") then
            return
        end
        -- Fallback to the default handler for other messages
        original_showMessage(_, result, ctx)
    end
end

ignore_rust_analyzer_errors()

require("presence").setup({
    neovim_image_text   = "i use neovim btw",
})
