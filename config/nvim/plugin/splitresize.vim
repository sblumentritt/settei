" --------------------------------------
" define split resizing
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_splitresize')
    finish
endif
let g:loaded_splitresize = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" key mappings
" --------------------------------------
if !exists('no_plugin_maps')
    if !hasmapto('<Plug>ToggleVertResize')
        nmap <unique> <silent> <leader>tvr <Plug>ToggleVertResize
    endif

    noremap <unique> <script> <Plug>ToggleVertResize :call <SID>vertical_resize_on_longest_line(1)<CR>
endif

" user commands
" --------------------------------------
if !exists(':ToggleVertResize')
    command -nargs=0 ToggleVertResize :call <SID>vertical_resize_on_longest_line(1)
endif

" autocommands
" --------------------------------------
augroup auto_resize
    autocmd!
    autocmd WinEnter * call <SID>vertical_resize_on_longest_line()
augroup END

" helper functions
" --------------------------------------
" resize split to longest line
if !exists('*s:vertical_resize_on_longest_line')
    function s:vertical_resize_on_longest_line(...)
        if !exists('g:toggle_vertical_resize')
            let g:toggle_vertical_resize = 0
        endif

        " for toggle behavior
        if a:0 == 1
            let g:toggle_vertical_resize = 1 - g:toggle_vertical_resize

            if g:toggle_vertical_resize == 0
                echomsg 'vertical resize: [enabled]'
            else
                echomsg 'vertical resize: [disabled]'
            endif
        endif

        if g:toggle_vertical_resize == 0
            let longest_line = max(map(getline(1, '$'), 'len(v:val)'))
            if longest_line > winwidth(0)
                execute 'vertical resize ' . (longest_line + 10)
            endif
        endif
    endfunction
endif

" cleanup
" --------------------------------------
" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
