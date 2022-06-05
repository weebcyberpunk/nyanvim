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

require('impatient')

-- PACKER BOOTSTRAP AND PLUGINS {{{
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	-- GOTTA GO FAST!
	use 'lewis6991/impatient.nvim'
	-- formating
	use 'ervandew/matchem'
	use 'windwp/nvim-ts-autotag'
	use { 'preservim/vim-pencil', opt = true, cmd = { 'HardPencil', 'Pencil', 'PencilHard', 'SoftPencil', 'PencilSoft', 'PencilToggle' } }
	use 'tpope/vim-commentary'
	use { 'dhruvasagar/vim-table-mode', opt = true, cmd = { 'TableModeEnable', 'TableModeToggle' }, keys = '<leader>tm', }
	-- files and filers
	use 'nvim-telescope/telescope.nvim'
	use 'nvim-lua/plenary.nvim' -- this is dependency. DON'T REMOVE UNLESS YOU KNOW WHAT YOU'RE DOING!
	use 'nvim-telescope/telescope-file-browser.nvim'
	-- git integration
	use  'lewis6991/gitsigns.nvim'
	use { 'tpope/vim-fugitive', opt = true, cmd = { 'G' } }
	-- make terminal great again
	use { 'voldikss/vim-floaterm', opt = true, keys = { '<C-t>', '<C-c>n', }, cmd = { 'FloatermNew', 'FloatermToggle' }, config = function()
		vim.cmd('hi FloatermBorder guibg=NONE')
	end 
	}
	-- appearance
	use { 'catppuccin/nvim', as = 'catppuccin', 
		-- commit = 'f079dda' 
	}
	-- visual
	use 'lukas-reineke/indent-blankline.nvim'
	use 'nvim-lualine/lualine.nvim'
	use 'startup-nvim/startup.nvim'
	-- unfortunatelly I cannot remove this from here
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
	end
	}
	use 'nvim-treesitter/nvim-treesitter'
	-- lsp, completion and all that modern stuff
	use 'simrat39/rust-tools.nvim'
	use 'p00f/clangd_extensions.nvim'
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	-- tetris
	use { 'alec-gibson/nvim-tetris', opt = true, cmd = 'Tetris' }
	-- Finally, the devicons (for safety is the least to be loaded)
	use 'kyazdani42/nvim-web-devicons'

	if packer_bootstrap then
		require('packer').sync()
	end
end)

require('gitsigns').setup()
require('nvim-ts-autotag').setup()
--- }}}

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
vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.laststatus = 3
vim.opt.spelllang = "en,pt" -- I'm brazilian so eventually I write portuguese
vim.opt.showmode = false -- this is only done because the mode is shown in lualine and in the cursor itself
vim.opt.mouse = "a"
-- }}}

-- KEYBINDS AND COMMANDS {{{
vim.keymap.set("n", "<Space><Space>", "/++<CR>2xi")

vim.api.nvim_create_user_command('Config', 'e ~/.config/nvim/init.lua', {})

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

-- telescope
vim.keymap.set("n", "<C-n>", ":Telescope file_browser<CR>")
vim.keymap.set("n", "<C-d>", ":Telescope diagnostics<CR>")
vim.keymap.set("n", "<C-s>", ":Telescope lsp_references<CR>")
vim.keymap.set("n", "<C-f>", ":Telescope git_files<CR>")
-- }}}

-- TERMINAL {{{
vim.g.floaterm_keymap_toggle = "<C-t>"
vim.g.floaterm_keymap_new = "<C-c>n"
vim.g.floaterm_keymap_next = "<C-c>l"
vim.g.floaterm_keymap_prev = "<C-c>h"
vim.keymap.set("n", "<C-c>p", ":FloatermNew python<CR>")
vim.keymap.set("n", "<C-c>f", ":FloatermNew lf<CR>")

vim.g.floaterm_width = vim.o.columns
vim.g.floaterm_height = 0.7
vim.g.floaterm_position = "bottom"
vim.g.floaterm_title = "Terminal $1"
vim.g.floaterm_borderchars = "─   ──  "
-- }}}

-- TELESCOPE {{{
local fb_actions = require "telescope".extensions.file_browser.actions
local actions = require("telescope.actions")
require('telescope').setup({
	defaults = {
		prompt_prefix = ': ',
		-- selection_caret = ' ',
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
		lsp_references = { theme = 'ivy', layout_config = { height = 0.7, }, },
		diagnostics = { theme = 'ivy', layout_config = { height = 0.7, }, },
		git_files = { theme = 'ivy', layout_config = { height = 0.7, }, },
	},
	extensions = {
		file_browser = {
			theme = 'ivy',
			layout_config = { height = 0.7, },
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
-- }}}

-- AUTOCMD {{{
local buf_settings = vim.api.nvim_create_augroup('buf_settings', {clear = true})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
	pattern = {
		'*.md',
		'*.html',
	},
	group = buf_settings,
	desc = 'Docs auto setting',
	callback = function()
		vim.cmd('HardPencil')
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
		'startup',
	},
	group = buf_settings,
	desc = 'Remove lualine from startup',
	callback = function()
		vim.cmd('setlocal laststatus=0')
	end
})
-- }}}

-- TREESITTER {{{
require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "python", "rust", "bash", "lua", "html" },
	highlight = { enable = true, },
}
-- }}}

-- APPEARANCE {{{
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

vim.opt.fillchars = vim.opt.fillchars + { eob = ' ' }

require("indent_blankline").setup {
	show_current_context = true,
}

-- }}}

-- STARTUP {{{
require"startup".setup({
	-- everything is padded because of signcolumn
	header = {
		type = "text",
		align = "center",
		title = "header",
		content = {
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
			-- '                        _ ',
			-- '                       | \\',
			-- '                       | |',
			-- '                       | |',
			-- '  |\\                   | |',
			-- ' /, ~\\                / / ',
			-- 'X     `-.....-------./ /  ',
			-- ' ~-. ~  ~              |  ',
			-- '    \\             /    |  ',
			-- '     \\  /_     ___\\   /   ',
			-- '     | /\\ ~~~~~   \\ |     ',
			-- '     | | \\        || |    ',
			-- '     | |\\ \\       || )    ',
			-- '    (_/ (_/      ((_/     ',
			' _______                    ____   ___.__         ',
			' \\      \\ ___._______    ___\\   \\ /   |__| _____  ', 
			' /   |   <   |  \\__  \\  /    \\   Y   /|  |/     \\ ',
			'/    |    \\___  |/ __ \\|   |  \\     / |  |  Y Y  \\',
			'\\____|__  / ____(____  |___|  /\\___/  |__|__|_|  /',
			'        \\/\\/         \\/     \\/                 \\/ ',
			-- '    _   __                _    ___         ',
			-- '   / | / /_  ______ _____| |  / (_)___ ___ ',
			-- '  /  |/ / / / / __ `/ __ \\ | / / / __ `__ \\',
			-- ' / /|  / /_/ / /_/ / / / / |/ / / / / / / /',
			-- '/_/ |_/\\__, /\\__,_/_/ /_/|___/_/_/ /_/ /_/ ',
			-- '      /____/                               ',
		},
		highlight = 'Conditional',
	},

	maps = {
		type = "mapping",
		title = "commands",
		align = "center",
		content = {
			{ " File Browser     ",  "Telescope file_browser",           "n" },
			{ "ﱐ New File     ",      "lua require 'startup'.new_file()", "e" },
			{ " Config     ",        "e ~/.config/nvim/init.lua",        "c" },
			{ " Sync Packages     ", "PackerSync",                       "u" },
			{ " Nyan!     ",         "term nyancat",                     "y" }
		},
		highlight = 'Question',
	},

	footer = {
		type = "text",
		title = "footer",
		align = "center",
		content = { "Welcome to NyanVim!   " },
		highlight = "Normal",
	},

	parts = { "header", "maps", "footer", },
})
-- }}}

-- STATUSLINE {{{
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
-- }}}

-- LSP AND COMPLETION {{{
local cmp = require'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f'] = cmp.mapping.scroll_docs(4),
		['<C-g>'] = cmp.mapping.complete(),
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
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { 'i', 's' }),
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
