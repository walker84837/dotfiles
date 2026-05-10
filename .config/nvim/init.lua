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

-- Folding: enable LSP folding globally (treesitter fallback at runtime)
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'v:lua.vim.lsp.foldexpr()'

-- Key bindings

-- Move lines
vim.api.nvim_set_keymap('n', '<S-Down>', ':m .+1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Up>', ':m .-2<CR>', { noremap = true, silent = true })

-- Open file browsers
vim.api.nvim_set_keymap('n', "<Leader>f", ":Neotree right<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<Leader>s", ":Telescope find_files<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<Leader>y", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Leader>y", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>Y", '"+Y', { noremap = true, silent = true })

-- Plugin options
vim.g.markdown_fenced_languages = { 'rust', 'toml', 'cpp', 'c', 'html', 'python', 'bash=sh' }
vim.g.rustfmt_autosave = 1
vim.g.NeoTreeRefreshToggleHidden = 1

local cmp = require("cmp")
local luasnip = require('luasnip')
local lualine = require('lualine')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Create augroup for resetting indentation
vim.api.nvim_create_augroup("lua_indent", { clear = true })

-- Set indentation for languages (4 spaces)
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "cs", "kotlin", "java", "lua", "javascript" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
    end,
})

vim.lsp.log.set_level("trace")
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client:supports_method("textDocument/codeLens") then
            -- refresh for this buffer
            vim.lsp.codelens.enable(true)

            -- set up refresh triggers
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = buf,
                callback = function()
                    vim.lsp.codelens.enable(true)
                end,
            })

            -- optional: keymap to run lenses
            vim.api.nvim_buf_set_keymap(buf, "n", "<leader>cl",
                "<cmd>lua vim.lsp.codelens.run()<CR>", { silent = true, noremap = true })
        end
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
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'fileformat' },
        lualine_c = { 'filename' },
        lualine_x = { 'diagnostics' },
        lualine_y = { 'encoding', 'filetype' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
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

local on_attach = function(client, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    -- LSP keybindings
    local opts = { buffer = bufnr, noremap = true, silent = true }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
    vim.keymap.set(
        'n', 'gi', vim.lsp.buf.implementation,
        vim.tbl_extend('force', opts, { desc = 'Go to implementation' })
    )
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover' }))
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename' }))

    -- LSP folding: use if client supports textDocument/foldingRange
    if client:supports_method('textDocument/foldingRange') then
        local win = vim.fn.bufwinid(bufnr)
        if win > 0 then
            vim.wo[win].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end
    end

    -- compile list of lsp servers to ignore formatting
    if client.name ~= "kotlin_language_server" then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false, bufnr = bufnr })
            end,
        })
    end
end

local lsp_servers = {
    "clangd", "gopls", "bashls", "jdtls", "omnisharp", "rust_analyzer",
    "kotlin_language_server", "lua_ls", "zls", "ruff", "vtsls"
}

for _, provider in ipairs(lsp_servers) do
    vim.lsp.config(provider, {
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

-- nvim-metals configuration
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt" },
    group = nvim_metals_group,
    callback = function()
        local metals_config = require("metals").bare_config()
        metals_config.on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            require("metals").setup_dap()
        end
        metals_config.capabilities = capabilities
        require("metals").initialize_or_attach(metals_config)
    end,
})

vim.lsp.config("jdtls", {
    settings = {
        java = {
            format = { enabled = false },
            import = {
                gradle = { enabled = true, wrapper = { enabled = true } },
                maven = { enabled = true },
            },
        },
    },
})

vim.lsp.config("vtsls", {
    -- https://github.com/yioneko/vtsls
    cmd = { 'vtsls', '--stdio' },
    filetypes = { 'javascript' }
})

vim.lsp.config("zls", {
    settings = {
        zls = {
            enable_build_on_save = true,
            semantic_tokens = "full",
        },
    },
})

-- vim.lsp.config("clangd", {
--     -- '--background-index'
--     cmd = { 'clangd', '--experimental-modules-support' },
--     on_attach = on_attach,
--     capabilities = capabilities,
-- })
vim.lsp.config("roslyn", {
    args = {},
    config = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            ["csharp|background_analysis"] = {
                dotnet_compiler_diagnostics_scope = "fullSolution",
            },
            ["csharp|inlay_hints"] = {
                dotnet_enable_inlay_hints_for_implicit_object_creation = true,
                dotnet_enable_inlay_hints_for_implicit_variable_types = true,
                dotnet_enable_inlay_hints_for_lambda_parameter_types = true,
                dotnet_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
        },
    },
})


vim.lsp.config("lua_ls", {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
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
    settings = {
        Lua = {}
    }
})

vim.lsp.config("kotlin_language_server", {
    filetypes = { "kotlin", "kt" },
    settings = {
        java = { format = { enabled = false }, },
        kotlin = {
            inlayHints = {
                typeHints = true,
                parameterHints = true,
                chainedHints = true
            }
        }
    },
    cmd_env = {
        KLS_LOG_LEVEL = 'ALL'
    },
    cmd = { '/home/winlogon/dev/kotlin/kotlin-lsp/kotlin-language-server/server/build/install/server/bin/kotlin-language-server' }
})

vim.lsp.config("rust_analyzer", {
    root_pattern = vim.fs.root(0, { "Cargo.toml", "" }),
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
    neovim_image_text = "i use neovim btw",
})

for _, server in ipairs(lsp_servers) do
    vim.lsp.enable(server)
end

-- Add nvim-treesitter runtime to rtp for query files
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime")

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
