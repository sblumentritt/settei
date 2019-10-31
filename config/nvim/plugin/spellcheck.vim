" --------------------------------------
" spellcheck toggle
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_spellcheck')
    finish
endif
let g:loaded_spellcheck = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" key mappings
" --------------------------------------
if !exists('no_plugin_maps')
    if !hasmapto('<Plug>ToggleSpellcheck')
        nmap <unique> <silent> <F11> <Plug>ToggleSpellcheck
    endif

    noremap <unique> <script> <Plug>ToggleSpellcheck :call <SID>toggle_spellcheck()<CR>
endif

" user commands
" --------------------------------------
if !exists(':ToggleSpellcheck')
    command -nargs=0 ToggleSpellcheck :call <SID>toggle_spellcheck()
endif

" helper functions
" --------------------------------------
" toggle spellcheck for the current buffer
function! s:toggle_spellcheck()
    if !exists('b:enable_spellcheck')
        let b:enable_spellcheck = 1
    else
        let b:enable_spellcheck = 1 - b:enable_spellcheck
    endif

    if b:enable_spellcheck == 0
        setlocal nospell
        echomsg 'spellchecking: [disabled]'
    else
        setlocal spell spelllang=en_us
        echomsg 'spellchecking: [enabled]'
    endif
endfunction

" cleanup
" --------------------------------------
" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
