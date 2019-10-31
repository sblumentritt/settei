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
setlocal textwidth=120
setlocal cinoptions+=L0
setlocal cinoptions+=:0
setlocal cinoptions+=b1
setlocal cinoptions+=g0
setlocal cinoptions+=N-s
setlocal commentstring=//\ %s

" key mappings
" --------------------------------------
if !exists('no_plugin_maps') && !exists('no_c_maps')
    nnoremap <silent> <buffer> <F4> :call <SID>header_source_switching()<CR>
endif

" helper functions
" --------------------------------------
" switch between headers/sources
if !exists('*s:header_source_switching')
    function s:header_source_switching()
        if expand('%:e') ==# 'c' || expand('%:e') ==# 'cpp'
            let l:header_file = ''
            let l:header_file_base = fnameescape(expand('%:p:r:s?src?include?'))

            let l:cxx_header = 0
            let l:found_header = 0

            " for c++ first check against .hpp extension
            if &filetype ==# 'cpp'
                let l:cxx_header = 1
                let l:header_name = l:header_file_base . '.hpp'
                let l:header_file = l:header_name

                " check if file is readable else if path contains include as subfolder
                if filereadable(l:header_name)
                    let l:found_header = 1
                elseif l:header_name =~# 'include'
                    " check if header file is aside the source file
                    let l:header_aside = substitute(l:header_name, 'include', 'src', 'g')
                    if filereadable(l:header_aside)
                        let l:header_file = l:header_aside
                        let l:found_header = 1
                    endif
                endif
            endif

            if !l:found_header
                let l:header_name = l:header_file_base . '.h'

                " check if file is readable else if path contains include as subfolder
                if filereadable(l:header_name)
                    let l:header_file = l:header_name
                elseif l:header_name =~# 'include'
                    " check if header file is aside the source file
                    let l:header_aside = substitute(l:header_name, 'include', 'src', 'g')
                    if filereadable(l:header_aside)
                        let l:header_file = l:header_aside
                    endif
                endif

                if empty(l:header_file)
                    let l:header_file = l:header_name
                endif
            endif

            exec 'edit' l:header_file

            " set correct filetype for header because .h files are normally c files
            if l:cxx_header
                set filetype=cpp
            endif

            " print full path of current file (after switch)
            let l:full_path = expand('%:p')
            redraw | echomsg l:full_path
        elseif expand('%:e') ==# 'h' || expand('%:e') ==# 'hpp'
            " define a possible path to a corresponding source file
            let l:source_file = fnameescape(expand('%:p:r:s?include?src?') . '.' . &filetype)

            " if file doesn't exist on disk or buffer
            " add include to header file in source file
            if !filereadable(l:source_file) && empty(bufname(l:source_file))
                let header = expand('%:s?include/??')
                exec 'edit' l:source_file |
                    \ call setline('.', '#include "' . header . '"') |
                    \ call append(line('$'), ['']) |
                    \ normal G
            else
                exec 'edit' l:source_file
            endif

            " print full path of current file (after switch)
            let l:full_path = expand('%:p')
            redraw | echomsg l:full_path
        endif
    endfunction
endif

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
