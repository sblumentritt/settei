" --------------------------------------
" configure built-in neovim options
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_options')
    finish
endif
let g:loaded_options = 1

syntax on
colorscheme susumu

set fileencoding=utf-8
set fileencodings=utf-8

set matchpairs+=<:>
set backspace=indent,eol,start

" don't wrap text if it is longer than the width of the window
set nowrap
" on bracket insert briefly jump to the matching one
set showmatch
" set maximum width of a text
set textwidth=100
" define the minimal width of a window
set winminwidth=20

" always show relative line numbers
set number
set relativenumber

" open splits below and to the right by default
set splitbelow
set splitright

set hlsearch
set incsearch
set smartcase
set ignorecase
" show effect of a command incrementally e.g. substitute
set inccommand=nosplit

set smarttab
set expandtab

set autoindent
set nosmartindent " disabled because deprecated and should not be used

" prevent special treatment of lines starting with '#'
set cinkeys-=0#
set indentkeys-=0#

set tabstop=4
set shiftwidth=4
set softtabstop=4

" raise dialog for e.g. unsaved changes in a buffer on quiet
set confirm
" disable backup files and bells
set nobackup
set noswapfile
set noerrorbells
set novisualbell
set nowritebackup

" show line and column number of cursor position
set ruler
" don't unload buffer when it is abandoned
set hidden
" disable folds and always have them open
set nofoldenable

" enable command-line completion suggestion
set wildmenu
" get old wildmenu style instead of new default popup menu style
set wildoptions=""

" enable mouse support for all modes
set mouse=a
" always use the clipboard for all operations
set clipboard+=unnamedplus
" settings for diff mode
set diffopt=vertical,filler,internal,algorithm:patience

" don't show extra information on completion
set completeopt-=preview
" show popup menu also for only one match
set completeopt+=menuone
" don't insert any text without user selection
set completeopt+=noinsert
" don't auto select a match in the menu
set completeopt+=noselect

" disable mode messages on last line
set noshowmode
" don't give ins-completion-menu messages e.g. 'match 1 of 2'
set shortmess+=c
" always show status line for last window
set laststatus=2
" always draw signcolumn
set signcolumn=yes

" if file changes outside of neovim read it again
set autoread
" time in milliseconds used for CursorHold autocommand
set updatetime=100

" disabling lazyredraw removes flickering cursor
set nolazyredraw

" enable if terminal supports 24-bit colors
set termguicolors

" change cursor shape if terminal supports it
set guicursor=n-c-r-cr:hor20,i-ci-ve:ver25,v:block

" enable persistent undo
if !isdirectory($neovim_data_dir . '/undo')
    call mkdir($neovim_data_dir . '/undo')
endif

set undodir=$neovim_data_dir/undo
set undofile

" improve session save option
set sessionoptions=blank,buffers,folds,help,localoptions,tabpages,winsize

" define backend for vimgrep/grep command
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --hidden\ --follow\ --ignore-vcs
    set grepformat=%f:%l:%c:%m
else
    set grepprg=grep\ -n\ --with-filename\ -I\ -R
    set grepformat=%f:%l:%m
endif

" use a whitespace as fill character for folds and end-of-buffer indication
set fillchars=fold:\ ,eob:\ ,diff:-

" fold related options
set foldlevel=99
set foldmethod=syntax
set foldtext=CustomFoldText()

" improved fold text for language which use braces '{}'
function! CustomFoldText()
    let l:line_start = getline(v:foldstart)
    let l:line_end = getline(v:foldend)

    let l:fold_text = l:line_start

    " check if the fold contains braces and handle them differently
    let l:filtered_start_brace = substitute(l:line_start, '^.*{.*$', '{', 'g')
    if l:filtered_start_brace == '{'
        let l:filtered_end_brace = substitute(l:line_end, '^.*}.*$', '}', 'g')
        if l:filtered_end_brace == '}'
            let l:fold_text = l:fold_text . substitute(l:line_end, '^.*}\(.*\)$', '...}\1', 'g')
        endif
    endif

    let l:fold_count = v:foldend - v:foldstart + 1

    return l:fold_text . ' > ' . l:fold_count
endfunction
