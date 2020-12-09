" --------------------------------------
" settings for various plugins
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_plugin_settings')
    finish
endif
let g:loaded_plugin_settings = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" gitgutter configurations
" --------------------------------------
let g:gitgutter_map_keys = 0

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_modified_removed = '~_'
let g:gitgutter_sign_removed_first_line = '‾'

if executable('rg')
    let g:gitgutter_grep = 'rg --color never --no-line-number'
endif

" cmake configurations
" --------------------------------------
let g:cmake#supported_languages = ['C', 'CXX']
let g:cmake#blacklist = [
            \ 'XCODE', 'ANDROID', 'OSX', 'VS',
            \ 'Fortran', 'Eclipse', 'ECLIPSE'
            \ ]

" vim-bbye configurations
" --------------------------------------
" close current buffer but keep splits
nnoremap gb :Bdelete<CR>

" vim-markdown configurations
" --------------------------------------
let g:markdown_syntax_conceal = 0
let g:markdown_fenced_languages = [
            \ 'cmake', 'c', 'cpp', 'vim', 'sh', 'rust',
            \ 'viml=vim', 'bash=sh'
            \ ]

" fzf configurations
" --------------------------------------
let g:fzf_buffers_jump = 1
let g:fzf_preview_window = ''
let g:fzf_layout = {'down': '~25%'}

" override default Rg implementation to include hidden files
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always'
            \   . ' --smart-case --hidden --glob "!.git" --glob "!dependency/**" '
            \   . shellescape(<q-args>),
            \   1, <bang>0
            \ )

" hide statusline in fzf buffer
augroup hide_fzf_statusline
    autocmd! FileType fzf
    autocmd FileType fzf set laststatus=0 noshowmode noruler
                \ | autocmd BufLeave <buffer> set laststatus=2 ruler
augroup END

" custom keybindings for fzf
nnoremap <silent> <F2> :Files<CR>
nnoremap <silent> <leader>fr :Rg<CR>
nnoremap <silent> <leader><F2> :Buffers<CR>

" undotree configurations
" --------------------------------------
let g:undotree_HelpLine = 0
let g:undotree_SplitWidth = 35
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 15
let g:undotree_SetFocusWhenToggle = 1

" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
