" --------------------------------------
" session management
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_sessions')
    finish
endif
let g:loaded_sessions = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" global variables
" --------------------------------------
" session folder in XDG data dir by default
let g:session_directory = stdpath('data') . '/site/session'

" key mappings
" --------------------------------------
if !exists('no_plugin_maps')
    if !hasmapto('<Plug>SaveSession')
        nmap <unique> <silent> <leader>S <Plug>SaveSession
    endif

    if !hasmapto('<Plug>LoadSession')
        nmap <unique> <silent> <leader>L <Plug>LoadSession
    endif

    noremap <unique> <script> <Plug>SaveSession :call <SID>save_session()<CR>
    noremap <unique> <script> <Plug>LoadSession :call <SID>load_session()<CR>
endif

" user commands
" --------------------------------------
if !exists(':SaveSession')
    command -nargs=0 SaveSession :call <SID>save_session()
endif

if !exists(':LoadSession')
    command -nargs=0 LoadSession :call <SID>load_session()
endif

" helper functions
" --------------------------------------
" save session under predefined path
function s:save_session()
    " write buffer if it has been modified
    update

    let session_name = input('Enter session name: ', '')
    if !empty(session_name)
        let session_file_path = g:session_directory . '/' . session_name

        " create session dir if not available
        if !isdirectory(g:session_directory)
            call mkdir(g:session_directory)
        endif

        " create session file
        exec 'mksession! ' . session_file_path

        " force a redraw to remove input message
        redraw

        " check if the file is readable
        if filereadable(session_file_path)
            echomsg 'Session ' . session_name . ' was saved!'
        else
            echohl ErrorMsg | echomsg 'Session ' . session_name . ' was not saved!' | echohl None
        endif
    endif
endfunction

" use skim to list and select a session file
function s:load_session()
    if exists('*fzf#run')
        if isdirectory(g:session_directory)
            call fzf#run(fzf#wrap({
                        \ 'sink': 'source',
                        \ 'dir': g:session_directory . '/',
                        \ 'options': '--prompt "Session > "'
                        \ }))
        else
            echohl ErrorMsg | echomsg '"' . g:session_directory . '" not available!' | echohl None
        endif
    else
        echohl ErrorMsg | echomsg 'FZF is not available which is required!' | echohl None
    endif
endfunction

" cleanup
" --------------------------------------
" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
