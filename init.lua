--  _______                    ____   ___.__
--  \      \ ___._______    ___\   \ /   |__| _____
--  /   |   <   |  \__  \  /    \   Y   /|  |/     \
-- /    |    \___  |/ __ \|   |  \     / |  |  Y Y  \
-- \____|__  / ____(____  |___|  /\___/  |__|__|_|  /
--         \/\/         \/     \/                 \/
--                         _
--     GG's NeoVim-based  | \
--       Personal IDE     | |
--                        | |
--   |\                   | |
--  /, ~\                / /
-- X     `-.....-------./ /
--  ~-. ~  ~              |
--     \             /    |
--      \  /_     ___\   /
--      | /\ ~~~~~   \ |
--      | | \        || |
--      | |\ \       || )
--     (_/ (_/      ((_/

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
else
	require('impatient')
end

require('packer').startup({function(use)
	use 'wbthomason/packer.nvim'

	-- GOTTA GO FAST!
	use 'lewis6991/impatient.nvim'

	-- FORMATTING {{{
	use 'ervandew/matchem'
	use { 'preservim/vim-pencil', opt = true, cmd = { 'HardPencil', 'Pencil', 'PencilHard', 'SoftPencil', 'PencilSoft', 'PencilToggle' } }
	use 'tpope/vim-commentary'
	use 'tpope/vim-surround'
	use { 'dhruvasagar/vim-table-mode', opt = true, cmd = { 'TableModeEnable', 'TableModeToggle' }, keys = '<leader>tm', }
	-- }}}

	-- FILES AND FILERS {{{
	use 'nvim-telescope/telescope-file-browser.nvim'
	use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim', config = function()
		local fb_actions = require "telescope".extensions.file_browser.actions
		local actions = require("telescope.actions")
		require('telescope').setup({
			defaults = {
				prompt_prefix = ': ',
				preview = { hide_on_startup = true, },
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<Tab>"] = actions.move_selection_next,
						["<S-Tab>"] = actions.move_selection_previous,
					},
				},
			},
			pickers = {
				lsp_references = { theme = 'ivy', layout_config = { height = 0.5, }, },
				git_files = { theme = 'ivy', layout_config = { height = 0.5, }, },
			},
			extensions = {
				file_browser = {
					theme = 'ivy',
					layout_config = { height = 0.5, },
					hidden = true,
					mappings = {
						["i"] = {
							["<C-a>"] = fb_actions.toggle_hidden,
							["<Space>"] = fb_actions.change_cwd,
							["<C-h>"] = fb_actions.goto_parent_dir,
							["<C-l>"] = fb_actions.change_cwd,
						},
					},
				},
			},
		})

		require('telescope').load_extension('file_browser')
	end, 
	}
	-- }}}

	-- GIT INTEGRATION {{{
	use { 'lewis6991/gitsigns.nvim', config = function()
		require('gitsigns').setup()
	end,
	}
	use { 'tpope/vim-fugitive', opt = true, cmd = { 'G' } }
	-- }}}

	-- TERMINAL AND TESTS {{{
	use { 'voldikss/vim-floaterm', opt = true, keys = { '<C-t>', '<C-c>n', }, cmd = { 'FloatermNew', 'FloatermToggle' }, setup = function()
		-- vim.g.floaterm_width = vim.o.columns
		vim.g.floaterm_width = 0.99
		vim.g.floaterm_height = 0.5
		vim.g.floaterm_position = "bottom"
		vim.g.floaterm_title = "Terminal $1"
		vim.g.floaterm_borderchars = "─   ──  "
	end, config = function()
		vim.cmd('hi FloatermBorder guibg=NONE')
	end, 
	}
	use { 'tpope/vim-dispatch', opt = true, cmd = { 'Make', 'Dispatch' } }
	-- }}}

	-- APPEARANCE AND VISUAL HELPERS {{{
	use { 'catppuccin/nvim', as = 'catppuccin', config = function()
		local catppuccin = require('catppuccin')
		catppuccin.setup({
			styles = {
				comments = 'italic',
				functions = 'italic',
				keywords = 'NONE',
				strings = 'NONE',
				variables = 'NONE',
			},
			transparent_background = true,
			term_colors = true,
			integrations = {
				indent_blankline = { enabled = true, },
			},
		})
		vim.g.catppuccin_flavour = "mocha"
		vim.cmd('colorscheme catppuccin')
	end
	}
	use { 'lukas-reineke/indent-blankline.nvim', config = function() 
		require("indent_blankline").setup {
			show_current_context = true,
		}
	end 
	}
	use { 'norcalli/nvim-colorizer.lua', config = function() 
		require('colorizer').setup(nil, {
			RGB      = true;
			RRGGBB   = true;
			names    = true;
			RRGGBBAA = true;
			rgb_fn   = true;
			hsl_fn   = true;
			css      = true;
			css_fn   = true;
		})
	end
	}
	-- }}}

	-- LUALINE {{{
	use { 'nvim-lualine/lualine.nvim', config = function()
		require('lualine').setup {
		sections = {
			lualine_a = {'mode'},
			lualine_b = {'filename'},
			lualine_c = {'diagnostics'},

			lualine_x = {'branch'},
			lualine_y = {'filetype'},
			lualine_z = {'location'}
			},
		options = {
			theme = 'auto',
			globalstatus = true
			},
		}
	end,
	}
	-- }}}

	-- ALPHA DASHBOARD {{{
	use { 'goolord/alpha-nvim', config = function()
		local alpha = require'alpha'
		local dashboard = require'alpha.themes.dashboard'
		dashboard.section.header.val = {
			-- '   ⢰⣧⣼⣯⠄⣸⣠⣶⣶⣦⣾⠄⠄⠄⠄⡀⠄⢀⣿⣿⠄⠄⠄⢸⡇⠄⠄    ',
			-- '   ⣾⣿⠿⠿⠶⠿⢿⣿⣿⣿⣿⣦⣤⣄⢀⡅⢠⣾⣛⡉⠄⠄⠄⠸⢀⣿⠄    ',
			-- '  ⢀⡋⣡⣴⣶⣶⡀⠄⠄⠙⢿⣿⣿⣿⣿⣿⣴⣿⣿⣿⢃⣤⣄⣀⣥⣿⣿⠄    ',
			-- '  ⢸⣇⠻⣿⣿⣿⣧⣀⢀⣠⡌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⠄    ',
			-- ' ⢀⢸⣿⣷⣤⣤⣤⣬⣙⣛⢿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡍⠄⠄⢀⣤⣄⠉⠋⣰    ',
			-- ' ⣼⣖⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⢇⣿⣿⡷⠶⠶⢿⣿⣿⠇⢀⣤    ',
			-- '⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣷⣶⣥⣴⣿⡗    ',
			-- '⢀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟     ',
			-- '⢸⣿⣦⣌⣛⣻⣿⣿⣧⠙⠛⠛⡭⠅⠒⠦⠭⣭⡻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃     ',
			-- '⠘⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⠄⠄⠄⠄⠹⠈⢋⣽⣿⣿⣿⣿⣵⣾⠃     ',
			-- ' ⠘⣿⣿⣿⣿⣿⣿⣿⣿⠄⣴⣿⣶⣄⠄⣴⣶⠄⢀⣾⣿⣿⣿⣿⣿⣿⠃      ',
			-- '  ⠈⠻⣿⣿⣿⣿⣿⣿⡄⢻⣿⣿⣿⠄⣿⣿⡀⣾⣿⣿⣿⣿⣛⠛⠁       ',
			-- '    ⠈⠛⢿⣿⣿⣿⠁⠞⢿⣿⣿⡄⢿⣿⡇⣸⣿⣿⠿⠛⠁         ',
			-- '       ⠉⠻⣿⣿⣾⣦⡙⠻⣷⣾⣿⠃⠿⠋⠁            ',
			-- '          ⠉⠻⣿⣿⡆⣿⡿⠃                ',
			-- '██████                    ████  ',
			-- '████  ▓▓                ▓▓  ██  ',
			-- '  ██    ██            ▓▓    ██  ',
			-- '  ██      ██▓▓▓▓████▓▓      ██  ',
			-- '  ██                        ██  ',
			-- '  ▓▓                        ██  ',
			-- '  ▓▓                        ██  ',
			-- '  ▓▓    ▓▓▓▓          ██    ██  ',
			-- '  ██░░▒▒    ██      ██  ██  ██  ',
			-- '  ▓▓██░░░░              ░░░░██  ',
			-- '    ██▓▓                  ██    ',
			-- '        ▓▓              ██      ',
			-- '          ▓▓██▓▓████████░░      ',
			'                        _ ',
			'                       | \\',
			'                       | |',
			'                       | |',
			'  |\\                   | |',
			' /, ~\\                / / ',
			'X     `-.....-------./ /  ',
			' ~-. ~  ~              |  ',
			'    \\             /    |  ',
			'     \\  /_     ___\\   /   ',
			'     | /\\ ~~~~~   \\ |     ',
			'     | | \\        || |    ',
			'     | |\\ \\       || )    ',
			'    (_/ (_/      ((_/     ',
			-- ' _______                    ____   ___.__         ',
			-- ' \\      \\ ___._______    ___\\   \\ /   |__| _____  ', 
			-- ' /   |   <   |  \\__  \\  /    \\   Y   /|  |/     \\ ',
			-- '/    |    \\___  |/ __ \\|   |  \\     / |  |  Y Y  \\',
			-- '\\____|__  / ____(____  |___|  /\\___/  |__|__|_|  /',
			-- '        \\/\\/         \\/     \\/                 \\/ ',
			-- '    _   __                _    ___         ',
			-- '   / | / /_  ______ _____| |  / (_)___ ___ ',
			-- '  /  |/ / / / / __ `/ __ \\ | / / / __ `__ \\',
			-- ' / /|  / /_/ / /_/ / / / / |/ / / / / / / /',
			-- '/_/ |_/\\__, /\\__,_/_/ /_/|___/_/_/ /_/ /_/ ',
			-- '      /____/                               ',
		}
		dashboard.section.buttons.val = {
			dashboard.button("n", " File Browser",  ":Telescope file_browser<CR>"),
			dashboard.button("e", "ﱐ New File",      ":enew<CR>"),
			dashboard.button("c", " Config",        ":cd ~/.config/nvim<CR>:e ~/.config/nvim/init.lua<CR>"),
			dashboard.button("u", " Sync Packages", ":PackerSync<CR>"),
			dashboard.button("y", " Nyan!",         ":term<CR>:set nonu<CR>:set nornu<CR>:setlocal signcolumn=no<CR>anyancat<CR>"),
		}
		dashboard.section.footer.val = 'Welcome to NyanVim!'

		dashboard.config.opts.noautocmd = true

		vim.cmd[[autocmd User AlphaReady echo 'ready']]

		alpha.setup(dashboard.config)
	end,
	}
	-- }}}

	-- ZEN MODE {{{
	use { 'folke/zen-mode.nvim', opt = true, cmd = { 'ZenMode' }, config = function()
		require('zen-mode').setup({
			window = {
				backdrop = 1,
				width = 85,
				height = 1,
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
					list = false,
				},
			},
		})
	end,
	}
	-- }}}

	-- TREESITTER {{{
	use { 'nvim-treesitter/nvim-treesitter', config = function()
		require'nvim-treesitter.configs'.setup {
			ensure_installed = { "c", "python", "rust", "bash", "lua", "markdown", "markdown_inline" },
			highlight = { enable = true, },
		}
	end,
	}
	-- }}}

	-- LSP, COMPLETION AND ALL THAT MODERN STUFF {{{
	use { 'folke/trouble.nvim', config = function()
		require('trouble').setup({
			auto_close = true,
		})
	end,
	}
	use 'simrat39/rust-tools.nvim'
	use 'p00f/clangd_extensions.nvim'
	use { 'hrsh7th/nvim-cmp', requires = {
		'neovim/nvim-lspconfig',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
	}, config = function() 
		-- LSP AND COMPLETION SETTINGS {{{
		local cmp = require'cmp'
		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-k>'] = cmp.mapping.scroll_docs(-4),
				['<C-j>'] = cmp.mapping.scroll_docs(4),
				['<C-l>'] = cmp.mapping.complete(),
				['<C-Space>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { 'i', 's', 'c' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { 'i', 's', 'c' }),
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
			}, {
				{ name = 'buffer' },
			}),
		})

		cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources({
				{ name = 'cmp_git' },
			}, {
				{ name = 'buffer' },
			})
		})

		cmp.setup.cmdline('/', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' }
			}
		})
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{ name = 'cmdline' }
			})
		})

		local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
		require('lspconfig')['pyright'].setup { capabilities = capabilities }

		require('rust-tools').setup()
		require('clangd_extensions').setup()
-- }}}
	end
	}
	-- }}}

	-- tetris
	use { 'alec-gibson/nvim-tetris', opt = true, cmd = 'Tetris' }
	-- Finally, the devicons (for safety is the least to be loaded)
	use 'kyazdani42/nvim-web-devicons'

	if packer_bootstrap then
		require('packer').sync()
	end
end,
config = {
	display = {
		open_fn = require('packer.util').float,
	}
}})

-- GREAT DEFAULTS {{{
vim.opt.textwidth = 80
vim.opt.foldmethod = "marker"
vim.opt.signcolumn = "yes:2"
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.path = vim.opt.path + "**"
vim.opt.ignorecase = true
vim.opt.scrolloff = 10
vim.opt.wildmode = "list:full"
vim.opt.wildignore = { "__pycache__/", "test.txt", "test*.txt", "LICENSE", "a.out", "*.gch", ".SRCINFO", ".git" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.completeopt = {"menuone", "noselect"}
vim.opt.laststatus = 3
vim.opt.spelllang = "en,pt" -- I'm brazilian so eventually I write portuguese
vim.opt.showmode = false -- this is only done because the mode is shown in lualine and in the cursor itself
vim.opt.mouse = "a"
-- }}}

-- KEYBINDS AND COMMANDS {{{
vim.keymap.set("n", "<Space><Space>", "/++<CR>2xi")

vim.api.nvim_create_user_command('Config', 'cd ~/.config/nvim | e ~/.config/nvim/init.lua', {})

-- navigation and splits
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "si", ":vsp<CR>")
vim.keymap.set("n", "su", ":sp<CR>")

-- snippets
vim.keymap.set("n", ";c", ":-1r ~/.config/nvim/snippets/skeleton.c<CR>7j8l :-1r ! date +'\\%b \\%d, \\%Y'<CR>kJ Gdd3k2l :let @a=expand('%t')<CR>\"aph2xl")
vim.keymap.set("n", ";ds", ":-1r ~/.config/nvim/snippets/script-doc.sh<CR>2j8l:r ! date +'\\%b \\%d, \\%Y'<CR>kJjdd")
vim.keymap.set("n", ";mitc", ":r ~/.config/nvim/snippets/mit.c<CR>j :r ! date +'\\%Y'<CR>kJJ")
vim.keymap.set("n", ";mits", ":-1r ~/.config/nvim/snippets/mit.sh<CR>j :r ! date +'\\%Y'<CR>kJJ")
vim.keymap.set("n", ";mitt", ":-1r ~/.config/nvim/snippets/mit.txt<CR>:r ! date +'\\%Y'<CR>kJJ")

-- all modern stuff
vim.keymap.set("n", "<C-d>", ":TroubleToggle<CR>")
vim.keymap.set("n", "<C-n>", ":Telescope file_browser<CR>")
vim.keymap.set("n", "<C-s>", ":Telescope lsp_references<CR>")
vim.keymap.set("n", "<C-f>", ":Telescope git_files<CR>")

-- term
vim.g.floaterm_keymap_toggle = "<C-t>"
vim.g.floaterm_keymap_new = "<C-c>n"
vim.g.floaterm_keymap_next = "<C-c>l"
vim.g.floaterm_keymap_prev = "<C-c>h"
vim.keymap.set("n", "<C-c>p", ":FloatermNew python<CR>")
vim.keymap.set("n", "<C-c>f", ":FloatermNew lf<CR>")
-- }}}

-- AUTOCMD {{{
local buf_settings = vim.api.nvim_create_augroup('buf_settings', {clear = true})
local win_settings = vim.api.nvim_create_augroup('win_settings', {clear = true})

vim.api.nvim_create_autocmd({'FileType'}, {
	pattern = {
		'markdown',
	},
	group = buf_settings,
	desc = 'Markdown auto setting',
	callback = function()
		vim.cmd('HardPencil')
		vim.cmd('setlocal spell')
	end
})

vim.api.nvim_create_autocmd({'FileType'}, {
	pattern = {
		'gitcommit',
	},
	group = buf_settings,
	desc = 'Commit auto setting',
	callback = function()
		vim.cmd('setlocal spell')
	end
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
	pattern = {
		'*.ms',
		'*.1',
		'*.2',
		'*.3',
		'*.4',
		'*.5',
		'*.6',
		'*.7',
	},
	group = buf_settings,
	desc = 'Groff auto setting',
	callback = function()
		vim.bo.filetype = "groff"
		vim.cmd('HardPencil')
		vim.cmd('setlocal spell')
	end
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
	pattern = {
		'Cargo.toml',
		'Cargo.lock',
		'*.rs',
	},
	group = buf_settings,
	desc = 'Rust make settings',
	callback = function()
		vim.bo.makeprg = 'cargo'
	end
})

vim.api.nvim_create_autocmd({'FileType'}, {
	pattern = {
		'python',
		'sh',
	},
	group = buf_settings,
	desc = 'Remove t from formatoptions from scripting langs',
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - 't'
	end
})

vim.api.nvim_create_autocmd({'FileType'}, {
	pattern = {
		'fugitive',
		'gitcommit',
		'git',
		'qf',
	},
	group = win_settings,
	desc = 'Clean screen on some windows',
	callback = function()
		vim.wo.relativenumber = false
		vim.wo.number = false
	end
})
-- }}}
