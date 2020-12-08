" --------------------------------------
" define general autocommands
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_autocommands')
    finish
endif
let g:loaded_autocommands = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" autocommands
" --------------------------------------
"  update filetypes
augroup update_filetypes
    autocmd!
    autocmd BufRead,BufNewFile *.{c,h} set filetype=c
    autocmd BufRead,BufNewFile .{clang-}* set filetype=yaml

    autocmd BufRead,BufNewFile config set filetype=config
    autocmd BufRead,BufNewFile *.{conf,config} set filetype=config

    autocmd BufRead,BufNewFile *.iwyu set filetype=iwyu

    autocmd Filetype yaml,xml,html,css,scss,less,javascript set
                \ tabstop=2
                \ shiftwidth=2
                \ softtabstop=2

    autocmd Filetype markdown set
                \ tabstop=2
                \ shiftwidth=2
                \ softtabstop=2
                \ textwidth=80
                \ colorcolumn=80
augroup END

" highlight keywords in the current window
augroup highlight_keywords
    autocmd!
    autocmd Syntax *
                \ call matchadd('GenericBold', '\W\zs\(TODO\|FIXME\|FIX\|BUG\|HACK\|ERROR\)') |
                \ call matchadd('GenericBold', '\W\zs\(NOTE\|INFO\|NOTICE\|DEBUG\)') |
augroup END

" remove trailing whitespace
augroup remove_trailing_whitespaces
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
augroup END

" disable number column in terminal buffer
augroup disable_term_num_col
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

augroup auto_close_windows
    autocmd!

    " close preview window if autocompletion popup is gone
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    " close quickfix and plugin windows automatically if main window is closed
    autocmd WinEnter * if winnr('$') == 1 &&
                        \ getbufvar(winbufnr(winnr()), '&buftype') == 'quickfix'
                        \ | q | endif
augroup END

" return to last edit position when opening files
augroup last_position
    autocmd!
    autocmd BufReadPost * call <SID>jump_last_position()

    function s:jump_last_position()
        execute 'filetype detect'
        if &filetype =~# 'commit'
            return
        else
            if line("'\"") > 1 && line("'\"") <= line('$')
                execute 'normal! g`"'
            endif
        endif
    endfunction
augroup END

" trigger autoread whenever switching buffer or focusing neovim again
augroup autoread_trigger
    autocmd!
    autocmd FocusGained,BufEnter * :silent! !
augroup END

" slowest but most accurate method which should fix broken syntax highlighting
augroup highlight_from_file_start
    autocmd!
    autocmd BufEnter * :syntax sync fromstart
augroup END

" automatically create a directory if it is not available on save of a file
augroup auto_mkdir
    autocmd!
    autocmd BufWritePre * call <SID>auto_mkdir_if_needed(expand('<afile>'),
                                                    \ +expand('<abuf>'))

    function s:auto_mkdir_if_needed(file, buf)
        if empty(getbufvar(a:buf, '&buftype')) && a:file !~# "\v^\w+\:\/"
            let dir = fnamemodify(a:file, ':h')
            if !isdirectory(dir)
                call mkdir(dir, 'p')
            endif
        endif
    endfunction
augroup END

" cleanup
" --------------------------------------
" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
