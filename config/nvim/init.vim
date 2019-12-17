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

" helper functions for vim-plug
" --------------------------------------
function! PatchCoc(info) abort
    if a:info.status !=# 'unchanged'
        let l:patch = stdpath('config') . '/patches/cosmetic_changes_for_coc.patch'
        execute '!patch -p1 -i ' . l:patch
        execute '!yarn install --frozen-lockfile'
        " call before 'git reset' else the diff is empty
        PlugDiff
        execute '!git reset --hard && git clean -f'
    endif
endfunction

" define plugins
" --------------------------------------
call plug#begin('$neovim_plugin_dir')

" require yarn/nodejs runtime
Plug 'https://github.com/neoclide/coc.nvim', {'do': function('PatchCoc')}
Plug 'https://github.com/iamcco/markdown-preview.nvim', {'do': 'yarn install --frozen-lockfile'}

" git related
Plug 'https://github.com/itchyny/vim-gitbranch'
Plug 'https://github.com/airblade/vim-gitgutter'
Plug 'https://github.com/rhysd/git-messenger.vim'
Plug 'https://github.com/samoshkin/vim-mergetool'

" c++ related
Plug 'https://github.com/rhysd/vim-clang-format'
Plug 'https://github.com/jackguo380/vim-lsp-cxx-highlight'
Plug 'https://github.com/vim-scripts/DoxygenToolkit.vim', {'on': 'Dox'}

" other filetype specific plugins
Plug 'https://github.com/cespare/vim-toml'
Plug 'https://github.com/rust-lang/rust.vim'
Plug 'https://github.com/tpope/vim-markdown'
Plug 'https://git.sr.ht/~sblumentritt/cmake.vim'
Plug 'https://github.com/MTDL9/vim-log-highlighting'
Plug 'https://git.sr.ht/~sblumentritt/bitbake.vim', {'branch': 'thud'}

" utilities
Plug 'https://github.com/moll/vim-bbye'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/mbbill/undotree', {'on': 'UndotreeToggle'}

" high-performance color highlighter
" slower vimscript alternative: https://github.com/lilydjwg/colorizer
Plug 'https://github.com/norcalli/nvim-colorizer.lua'

call plug#end()
filetype plugin indent on
