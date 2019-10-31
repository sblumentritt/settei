" --------------------------------------
" handle quicklist/loclist close
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_listclose')
    finish
endif
let g:loaded_listclose = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" key mappings
" --------------------------------------
if !exists('no_plugin_maps')
    if !hasmapto('<Plug>CloseList')
        nmap <unique> <silent> <ESC> <Plug>CloseList
    endif

    noremap <unique> <script> <Plug>CloseList :call <SID>close_list()<CR>
endif

" user commands
" --------------------------------------
if !exists(':CloseList')
    command -nargs=0 CloseList :call <SID>close_list()
endif

" helper functions
" --------------------------------------
" check if buffer is quicklist or loclist and call current close command
function! s:close_list()
    silent exec 'redir @a | ls | redir END'
    if match(@a, '%a-  "\[Location List\]"') >= 0
        exec 'lclose'
    elseif match(@a, '%a-  "\[Quickfix List\]"') >= 0
        exec 'cclose'
    endif
endfunction

" cleanup
" --------------------------------------
" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
