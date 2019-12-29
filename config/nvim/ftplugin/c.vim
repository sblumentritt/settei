" --------------------------------------
" c filetype configurations
" --------------------------------------
" avoid executing the plugin twice
if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" update options
" --------------------------------------
setlocal textwidth=100
setlocal cinoptions+=L0
setlocal cinoptions+=:0
setlocal cinoptions+=b1
setlocal cinoptions+=g0
setlocal cinoptions+=N-s
setlocal commentstring=//\ %s

" cleanup
" --------------------------------------
"  reset options on filetype change
let b:undo_ftplugin =
            \           'setlocal textwidth<'
            \ . ' | ' . 'setlocal cinoptions<'
            \ . ' | ' . 'setlocal commentstring<'

" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
