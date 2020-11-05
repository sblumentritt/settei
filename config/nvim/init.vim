" --------------------------------------
" entry point for neovim
" --------------------------------------

" define value for <leader> as early as possible
" --------------------------------------
let g:mapleader = ','

" save paths as vimscript environment variables
" --------------------------------------
let $neovim_data_dir = stdpath('data') . '/site'
let $neovim_plugin_dir = $neovim_data_dir . '/plugged'

" check if vim-plug is installed
" --------------------------------------
if !filereadable($neovim_data_dir . '/autoload/plug.vim')
    silent !curl -fLo $neovim_data_dir/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" disable some standard plugins
" --------------------------------------
let g:loaded_gzip = 1

let g:loaded_tar = 1
let g:loaded_tarPlugin = 1

let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" define plugins
" --------------------------------------
call plug#begin('$neovim_plugin_dir')

" completion related
Plug 'https://github.com/nvim-lua/completion-nvim'
Plug 'https://github.com/steelsojka/completion-buffers'

" lsp related
Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'https://github.com/nvim-lua/lsp-status.nvim'
Plug 'https://github.com/nvim-lua/diagnostic-nvim'

" git related
Plug 'https://github.com/itchyny/vim-gitbranch'
Plug 'https://github.com/airblade/vim-gitgutter'
Plug 'https://github.com/rhysd/git-messenger.vim'
Plug 'https://github.com/samoshkin/vim-mergetool'


" other filetype specific plugins
Plug 'https://github.com/cespare/vim-toml'
Plug 'https://github.com/tpope/vim-markdown'
Plug 'https://github.com/MTDL9/vim-log-highlighting'
Plug 'https://github.com/euclidianAce/BetterLua.vim'

Plug 'https://gitlab.com/s.blumentritt/cmake.vim'
Plug 'https://gitlab.com/s.blumentritt/bitbake.vim'

" utilities
Plug 'https://github.com/moll/vim-bbye'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/camspiers/lens.vim'
Plug 'https://github.com/norcalli/nvim-colorizer.lua'
Plug 'https://github.com/mbbill/undotree', {'on': 'UndotreeToggle'}

call plug#end()
filetype plugin indent on
