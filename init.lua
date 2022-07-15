--  _______                    ____   ___.__
--  \      \ ___._______    ___\   \ /   |__| _____
--  /   |   <   |  \__  \  /    \   Y   /|  |/     \
-- /    |    \___  |/ __ \|   |  \     / |  |  Y Y  \
-- \____|__  / ____(____  |___|  /\___/  |__|__|_|  /
--         \/\/         \/     \/                 \/
--                         _
--     GG's NeoVim-based  | \
--       Personal IDE     | |
--    - minimal edition - | |
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

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- GOTTA GO FAST!
    use 'lewis6991/impatient.nvim'

    -- FORMATTING {{{
    use 'tpope/vim-commentary'
    use 'ervandew/matchem'
    use { 'preservim/vim-pencil', opt = true, cmd = { 'HardPencil', 'Pencil', 'PencilHard', 'SoftPencil', 'PencilSoft', 'PencilToggle' } }
    use { 'dhruvasagar/vim-table-mode', opt = true, cmd = { 'TableModeEnable', 'TableModeToggle' }, keys = '<leader>tm', }
    -- }}}

    -- INTEGRATIONS {{{
    use { 'lewis6991/gitsigns.nvim', config = function()
        require('gitsigns').setup({
            signcolumn = false,
            numhl = true,
        })
    end,
    }
    use 'tpope/vim-eunuch'
    use { 'tpope/vim-fugitive', opt = true, cmd = { 'G' } }
    use { 'weebcyberpunk/run.vim', opt = true, cmd = { 'Run', 'Compile' }, config = function()
        vim.g.run_compilewin_cmd = 'tabnew'
    end,
    }
    use 'weebcyberpunk/lf.vim'
    -- }}}

    -- APPEARANCE AND VISUAL HELPERS {{{
    use { 'catppuccin/nvim', as = 'catppuccin', config = function() 
        -- COLORSCHEME SETTINGS {{{
        -- not load colorscheme on framebuffer
        if os.getenv("TERM") == "linux" then
            vim.cmd("hi SignColumn ctermbg=NONE guibg=NONE")
            vim.cmd("hi Pmenu ctermbg=NONE guibg=NONE ctermfg=Magenta guifg=Magenta")
            vim.cmd("hi PmenuSel ctermbg=Magenta guibg=Magenta ctermfg=White guifg=White")
            vim.opt.guicursor = ""
            return
        end
        local catppuccin = require('catppuccin')
        vim.opt.fillchars = vim.opt.fillchars + "eob: "
        catppuccin.setup({
            transparent_background = true,
            styles = {
                comments = 'italic',
                functions = 'italic',
                keywords = 'NONE',
                strings = 'NONE',
                variables = 'NONE',
            },
            term_colors = true,
            integrations = {
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = "italic",
                        hints = "italic",
                        warnings = "italic",
                        information = "italic",
                    },
                    underlines = {
                        errors = "underline",
                        hints = "underline",
                        warnings = "underline",
                        information = "underline",
                    },
                },
                cmp = true,
                gitsigns = true,
                treesitter = true,
            },
        })
        vim.g.catppuccin_flavour = "mocha" -- frappe latte macchiato mocha
        vim.cmd('colorscheme catppuccin')
        -- }}}
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
    use 'caenrique/swap-buffers.nvim'
    use { 'weebcyberpunk/statusbufferline.vim', config = function() 
        vim.opt.showtabline = 2
    end,
    }
    -- }}}

    -- TREESITTER {{{
    use { 'nvim-treesitter/nvim-treesitter', config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = { "c", "python", "rust", "bash", "lua", "markdown", "markdown_inline", "html", "css", "javascript" },
            highlight = { enable = true, },
        }
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

    -- LSP, COMPLETION AND ALL THAT MODERN STUFF {{{
    use 'simrat39/rust-tools.nvim'
    use 'p00f/clangd_extensions.nvim'
    use { 'hrsh7th/nvim-cmp', requires = {
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
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
            })
        })

        local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
        require('lspconfig')['pyright'].setup({capabilities = capabilities})
        require('rust-tools').setup()
        require('clangd_extensions').setup()
-- }}}
    end
    }
    -- }}}

    if packer_bootstrap then
        require('packer').sync()
    end
end
)

-- GREAT DEFAULTS {{{
vim.opt.textwidth = 80
vim.opt.foldmethod = "marker"
vim.opt.signcolumn = "no"
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
vim.opt.laststatus = 3
vim.opt.spelllang = "en,pt" -- I'm brazilian so eventually I write portuguese
vim.opt.mouse = "a"
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = vim.opt.clipboard + "unnamedplus"
-- }}}

-- KEYBINDS AND COMMANDS {{{
vim.keymap.set("n", "<Space><Space>", "/++<CR>2xi")

vim.api.nvim_create_user_command('Config', 'cd ~/.config/nvim | e ~/.config/nvim/init.lua', {})
vim.api.nvim_create_user_command('WinReset', 'set number | set relativenumber | set signcolumn=no', {})
vim.api.nvim_create_user_command('LightTheme', 'let g:catppuccin_flavour="latte" | colorscheme catppuccin', {})
vim.api.nvim_create_user_command('DarkTheme', 'let g:catppuccin_flavour="mocha" | colorscheme catppuccin', {})
vim.api.nvim_create_user_command('BdOthers', '%bd|e#', {})

-- MIT LICENSE
vim.api.nvim_create_user_command('Mit', 'source ~/.config/nvim/scripts/mit.vim', {})
vim.api.nvim_create_user_command('Mitc', 'source ~/.config/nvim/scripts/mitc.vim', {})
vim.api.nvim_create_user_command('Mits', 'source ~/.config/nvim/scripts/mits.vim', {})

-- navigation and splits
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "si", ":vsp<CR>")
vim.keymap.set("n", "su", ":sp<CR>")
vim.keymap.set("n", "<C-n>", ":LfChangeCwd<CR>")
vim.keymap.set("n", "<C-f>", ":Lf<CR>")

-- buffers
vim.keymap.set("n", "<C-s>h", ":lua require('swap-buffers').swap_buffers('h')<CR>")
vim.keymap.set("n", "<C-s>j", ":lua require('swap-buffers').swap_buffers('j')<CR>")
vim.keymap.set("n", "<C-s>k", ":lua require('swap-buffers').swap_buffers('k')<CR>")
vim.keymap.set("n", "<C-s>l", ":lua require('swap-buffers').swap_buffers('l')<CR>")
vim.keymap.set("n", "gp", ":bp<CR>")
vim.keymap.set("n", "gn", ":bn<CR>")

-- term and test
vim.keymap.set("n", "<C-p>", ":Run python<CR>")
vim.keymap.set("n", "<C-c>p", ":Run python -i -c 'import math; from math import *'<CR>")
vim.keymap.set("n", "<C-c>j", ":Run node<CR>")
vim.keymap.set("n", "<C-c>h", ":Run ghci<CR>")
vim.keymap.set("n", "<C-c>s", ":Run htop<CR>")
vim.keymap.set("n", "<C-c>m", ":Run ncmpcpp<CR>")
vim.keymap.set("n", "<C-t>", ":Run<CR>")
vim.keymap.set("n", "<C-b>", ":Compile<CR>")
-- }}}

-- AUTOCMD {{{

-- BUF SETTINGS {{{
local buf_settings = vim.api.nvim_create_augroup('buf_settings', {clear = true})

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

vim.api.nvim_create_autocmd({'FileType'}, {
    pattern = {
        'fugitive',
    },
    group = buf_settings,
    desc = 'Fugitive auto setting',
    callback = function()
        vim.cmd('normal 4j')
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
-- }}}

-- WINDOW SETTINGS {{{
local win_settings = vim.api.nvim_create_augroup('win_settings', {clear = true})

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
        vim.wo.signcolumn = 'no'
    end
})

vim.api.nvim_create_autocmd({'TermEnter'}, {
    pattern = '*',
    group = win_settings,
    desc = 'Clean terminal window',
    callback = function()
        vim.wo.relativenumber = false
        vim.wo.number = false
        vim.wo.signcolumn = 'no'
    end
})

vim.api.nvim_create_autocmd({'TermLeave'}, {
    pattern = '*',
    group = win_settings,
    desc = 'Reset window after terminal',
    callback = function()
        vim.wo.relativenumber = true
        vim.wo.number = true
        vim.wo.signcolumn = 'no'
    end
})
-- }}}

-- SNIPPETS {{{
local snippets = vim.api.nvim_create_augroup('snippets', {clear = true})

vim.api.nvim_create_autocmd({'BufNewFile'}, {
    pattern = '*.c',
    group = snippets,
    desc = 'C snippet',
    command = "source ~/.config/nvim/scripts/c_snippet.vim"
})

vim.api.nvim_create_autocmd({'BufNewFile'}, {
    pattern = '*.py',
    group = snippets,
    desc = 'Python snippet',
    command = "source ~/.config/nvim/scripts/py_snippet.vim"
})

vim.api.nvim_create_autocmd({'BufNewFile'}, {
    pattern = '*.sh',
    group = snippets,
    desc = 'Shell snippet',
    command = "source ~/.config/nvim/scripts/sh_snippet.vim"
})

vim.api.nvim_create_autocmd({'BufNewFile'}, {
    pattern = '*.html',
    group = snippets,
    desc = 'HTML snippet',
    command = "source ~/.config/nvim/scripts/html_snippet.vim"
})
-- }}}

-- COLORSCHEME OVERWRITES {{{
local color_settings = vim.api.nvim_create_augroup('color_settings', {clear = true})
vim.api.nvim_create_autocmd({'Colorscheme'}, {
    pattern = '*',
    group = color_settings,
    desc = 'Colorscheme autosettings',
    command = "source ~/.config/nvim/scripts/colorscheme.vim"
})
-- }}}

-- }}}
