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
    use { 'junegunn/vim-easy-align', config = function()
        vim.cmd("nmap ga <Plug>(EasyAlign)")
        vim.cmd("xmap ga <Plug>(EasyAlign)")
    end,
    }
    use 'junegunn/vim-markdown-toc'
    use { 'preservim/vim-pencil', opt = true, cmd = { 'HardPencil', 'Pencil', 'PencilHard', 'SoftPencil', 'PencilSoft', 'PencilToggle' } }
    use { 'dhruvasagar/vim-table-mode', opt = true, cmd = { 'TableModeEnable', 'TableModeToggle' }, keys = '<leader>tm', }
    -- }}}

    -- INTEGRATIONS {{{
    use 'tpope/vim-eunuch'
    use { 'tpope/vim-fugitive', opt = true, cmd = { 'G' } }
    use { 'weebcyberpunk/run.vim', opt = true, cmd = { 'Run', 'Compile' }, config = function()
        vim.g.run_compilewin_cmd = 'tabnew'
        vim.g.run_runwin_cmd = 'tabnew'
    end,
    }
    use { 'weebcyberpunk/lf.vim', config = function()
        vim.g.lf_change_cwd_cmd = 'cd'
    end,
    }
    -- }}}

    -- APPEARANCE AND VISUAL HELPERS {{{
    -- CATPPUCCIN {{{
    use { 'catppuccin/nvim', as = 'catppuccin', config = function() 
        local catppuccin = require('catppuccin')
        catppuccin.setup({
            transparent_background = true,
            compile = { enabled = false, },
            styles = {
                comments = { 'italic' },
                functions = { 'italic' },
            },
            term_colors = true,
            integrations = {
                lsp_trouble = true,
            },
        })
    end
    }
    -- }}}
    -- SOLARIZED {{{
    use 'maxmx03/solarized.nvim'
    -- }}}
    use { 'RRethy/vim-hexokinase', run = 'make hexokinase', config = function()
        vim.g.Hexokinase_highlighters = { 'backgroundfull' }
    end,
    }
    use 'caenrique/swap-buffers.nvim'
    use 'junegunn/vim-slash'
    use { 'weebcyberpunk/statusbufferline.vim', config = function() 
        vim.opt.showtabline = 2
    end,
    }
    -- }}}

    -- TREESITTER {{{
    use { 'nvim-treesitter/nvim-treesitter', config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = { "c", "python", "rust", "bash", "lua", "markdown", "markdown_inline", "html", "css", "javascript", "haskell" },
            highlight = { enable = true, },
        }
    end,
    }
    -- }}}

    -- LSP, COMPLETION AND ALL THAT MODERN STUFF {{{
    use { 'ervandew/supertab', config = function()
        vim.cmd("source ~/.config/nvim/scripts/supertab-completion.vim")
    end,
    }
    use { 'neovim/nvim-lspconfig', config = function()

        vim.keymap.set("n", "<C-d>", vim.diagnostic.setloclist)
        vim.keymap.set("n", "<C-e>", vim.diagnostic.open_float)

        local on_attach = function(client, bufnr)

            vim.api.nvim_buf_set_option(bufnr, 'completefunc', 'v:lua.vim.lsp.omnifunc')

            local bufopts = { buffer = bufnr }

            vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition,  bufopts)
            vim.keymap.set('n', 'K',     vim.lsp.buf.hover,       bufopts)
            vim.keymap.set('n', '<C-q>', vim.lsp.buf.code_action, bufopts)
        end

        require('lspconfig')['pyright'].setup({on_attach = on_attach})
        require('lspconfig')['clangd'].setup({on_attach = on_attach})
        require('lspconfig')['rust_analyzer'].setup({on_attach = on_attach})
    end,
    }
    -- }}}

    if packer_bootstrap then
        require('packer').sync()
    end
end
)

-- GREAT DEFAULTS {{{
-- editing
vim.opt.textwidth      = 80
vim.opt.foldmethod     = "marker"
vim.opt.wrap           = false
vim.opt.ignorecase     = true
vim.opt.splitbelow     = true
vim.opt.splitright     = true
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true

-- appearance
vim.opt.signcolumn     = "no"
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.termguicolors  = true
vim.opt.scrolloff      = 5
vim.opt.laststatus     = 3
vim.opt.cursorline     = true

-- wildmenu/completion
vim.opt.wildmode       = "list:full"
vim.opt.wildignore     = { "__pycache__/", "test.txt", "test*.txt", "LICENSE", "a.out", "*.gch", ".SRCINFO", ".git" }
vim.opt.completeopt    = "menu"

-- others
vim.opt.clipboard      = vim.opt.clipboard + "unnamedplus"
vim.opt.mouse          = "a"
vim.opt.spelllang      = "en,pt" -- I'm brazilian so eventually I write portuguese
vim.opt.path           = vim.opt.path + "**"

-- }}}

-- KEYBINDS AND COMMANDS {{{
vim.keymap.set("n", "<Space><Space>", "/++<CR>2xi")

vim.api.nvim_create_user_command('Config', 'cd ~/.config/nvim | e ~/.config/nvim/init.lua', {})
vim.api.nvim_create_user_command('WinReset', 'set number | set relativenumber | set signcolumn=no', {})
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

-- term, test, etc
vim.keymap.set("n", "<C-p>", ":Run python<CR>")
vim.keymap.set("n", "<C-c>p", ":Run ~/.local/bin/calculator<CR>")
vim.keymap.set("n", "<C-c>j", ":Run node<CR>")
vim.keymap.set("n", "<C-c>h", ":Run ghci<CR>")
vim.keymap.set("n", "<C-c>s", ":Run htop<CR>")
vim.keymap.set("n", "<C-c>m", ":Run ncmpcpp<CR>")
vim.keymap.set("n", "<C-t>", ":Run<CR>")
vim.keymap.set("n", "<C-b>", ":Compile<CR>")

-- i usually start vim from <term> -e nvim so this prevents I crashing it with
-- C-z
vim.keymap.set("n", "<C-z>", ":echo 'remap this to something lol'<CR>")
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

-- }}}

-- COLORSCHEME {{{
-- not load colorscheme on framebuffer
if os.getenv("TERM") == "linux" then

    vim.cmd("hi SignColumn ctermbg=NONE guibg=NONE")
    vim.cmd("hi Pmenu ctermbg=NONE guibg=NONE ctermfg=Magenta guifg=Magenta")
    vim.cmd("hi PmenuSel ctermbg=Magenta guibg=Magenta ctermfg=White guifg=White")
    vim.opt.guicursor = ""
else

    -- symlink for the script
    vim.cmd('source ~/.config/nvim/scripts/colorscheme.vim')
end

-- }}}
