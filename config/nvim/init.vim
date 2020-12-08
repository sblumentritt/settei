" --------------------------------------
" entry point for neovim
" --------------------------------------

" define value for <leader> as early as possible
" --------------------------------------
let g:mapleader = ','

" save paths as vimscript environment variables
" --------------------------------------
let $neovim_data_dir = stdpath('data') . '/site'
let $neovim_plugin_dir = $neovim_data_dir . '/pack/packer/start'

" disable some standard plugins
" --------------------------------------
let g:loaded_gzip = 1

let g:loaded_tar = 1
let g:loaded_tarPlugin = 1

let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

lua require('plugins')

" always install missing plugins when starting
PackerInstall

filetype plugin indent on
