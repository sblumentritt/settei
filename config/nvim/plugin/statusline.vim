" --------------------------------------
" personal statusline
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_statusline')
    finish
endif
let g:loaded_statusline = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" set statusline option
" --------------------------------------
set statusline=%!CustomStatusline(1)

" autocommands
" --------------------------------------
augroup auto_statusline_change
    autocmd!
    autocmd WinLeave * setlocal statusline=%!CustomStatusline(0)
    autocmd CmdlineEnter : setlocal statusline=%!CustomStatusline(0)

    autocmd CmdWinEnter : setlocal statusline=%!CustomStatusline(1)
    autocmd CmdlineLeave : setlocal statusline=%!CustomStatusline(1)
    autocmd BufWinEnter,WinEnter * setlocal statusline=%!CustomStatusline(1)
augroup END

" helper functions
" --------------------------------------
function! CustomStatusline(current)
    return
            \ ModeStatus()
            \ . (a:current ? '%#StatusLayerOne#' : '%#StatusLayerOneInactive#')
            \ . '  ' . '%t' . '%{ModifiedStatus()}  '
            \ . (a:current ? '%#StatusLayerTwo#' : '%#StatusLayerTwoInactive#')
            \ . '%='
            \ . '%{GitChanges()}'
            \ . '%{GitBranch()}'
            \ . (a:current ? '%#StatusLayerOne#' : '%#StatusLayerOneInactive#')
            \ . DiagnosticStatus()
endfunction

function! ModeStatus()
    let l:currentmode = mode()
    let l:mapped_mode = ''

    if l:currentmode =~# '[ncit]'
        let l:mapped_mode = l:currentmode
    elseif l:currentmode =~# '[vVsS]' || l:currentmode ==# '<C-V>' || l:currentmode ==# '<C-S>'
        let l:mapped_mode = 'v'
    elseif l:currentmode ==# 'R'
        let l:mapped_mode = 'r'
    else
        let l:mapped_mode = ''
    endif

    let l:mode_labels = {
                \ 'n': '  NORMAL  ',
                \ 'i': '  INSERT  ',
                \ 'v': '  VISUAL  ',
                \ 'c': '  COMMAND  ',
                \ 'r': '  REPLACE  ',
                \ 't': '  TERMINAL  ',
                \ '': '',
                \ }

    let l:mode_colors = {
                \ 'n': '%#ModeStatusNormal#',
                \ 'i': '%#ModeStatusInsert#',
                \ 'v': '%#ModeStatusVisual#',
                \ 'c': '%#ModeStatusCommand#',
                \ 'r': '%#ModeStatusReplace#',
                \ 't': '%#ModeStatusTerminal#',
                \ '': '',
                \ }

    return l:mode_colors[l:mapped_mode] . l:mode_labels[l:mapped_mode]
endfunction

function! ModifiedStatus()
    return &modified ? ' *' : ''
endfunction

function! GitBranch()
    let l:branch = ''

    if exists('g:loaded_gitbranch')
        let l:branch = gitbranch#name()
    endif

    return l:branch == '' ? l:branch : printf('%s :: ', l:branch)
endfunction

function! GitChanges()
    let l:total = 0

    if exists('g:loaded_gitgutter')
        let l:summary = gitgutter#hunk#summary(bufnr(''))
        let l:total = l:summary[0] + l:summary[1] + l:summary[2]
    endif

    return l:total == 0 ? '' : printf('+%d ~%d -%d :: ', l:summary[0], l:summary[1], l:summary[2])
endfunction

function! DiagnosticStatus() abort
    let l:lsp_error_count = 0
    let l:lsp_warning_count = 0

    let l:coc_diagnostic = get(b:, 'coc_diagnostic_info', {})
    if !empty(l:coc_diagnostic)
        let l:lsp_error_count = get(l:coc_diagnostic, 'error', 0)
        let l:lsp_warning_count = get(l:coc_diagnostic, 'warning', 0)
    endif

    let l:total_count = l:lsp_error_count + l:lsp_warning_count

    let l:diagnostic_ok_color = '%#DiagnosticStatusOk#'
    let l:diagnostic_error_color = '%#DiagnosticStatusError#'
    let l:diagnostic_warning_color = '%#DiagnosticStatusWarning#'

    return l:total_count == 0 ? printf('%s  OK  ', l:diagnostic_ok_color) :
                \ printf('%s %dW %s %dE ',
                \        l:diagnostic_warning_color,
                \        l:lsp_warning_count,
                \        l:diagnostic_error_color,
                \        l:lsp_error_count)
endfunction

" cleanup
" --------------------------------------
" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
