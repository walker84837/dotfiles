set number
set termguicolors
set relativenumber
set incsearch
set mouse=

call plug#begin()

" Core Plugins
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'

" LSP & Language Support
Plug 'neovim/nvim-lspconfig'
Plug 'georgewfraser/java-language-server'
Plug 'Decodetalkers/csharpls-extended-lsp.nvim'
Plug 'rust-lang/rust.vim'
Plug 'ziglang/zig.vim'
Plug 'heavenshell/vim-jsdoc'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'fatih/vim-go'

" Completion & Snippets
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'petertriho/cmp-git'
Plug 'hrsh7th/cmp-nvim-lsp'

" File Explorer & Icons
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'

" Appearance & Themes
Plug 'nvim-lualine/lualine.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'shaunsingh/nord.nvim'
Plug 'shaunsingh/solarized.nvim'

" Miscellaneous Plugins
Plug 'alx741/vinfo'
Plug 'andweeb/presence.nvim'
Plug 'nvim-lua/plenary.nvim'

call plug#end()

" Colorscheme
colorscheme catppuccin-mocha

" Key bindings
nnoremap <S-Down> :m .+1<CR>
nnoremap <S-Up> :m .-2<CR>
nnoremap <C-F> :%!rustfmt --edition 2021<CR>
nnoremap <C-d> :%!cmark -t commonmark --width 80<CR>

" Plugin options
let g:markdown_fenced_languages = [ 'rust', 'toml', 'cpp', 'c', 'html', 'python', 'bash=sh' ]
let g:rustfmt_autosave = 1
let g:NeoTreeRefreshToggleHidden = 1

lua << EOF
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

	local cmp = require("cmp")

	cmp.setup({
		snippet = {
			expand = function(args)
				require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		window = {
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
EOF
