" --------------------------------------
" coc configurations
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_coc_settings')
    finish
endif
let g:loaded_coc_settings = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" check if plugin is available
if isdirectory($neovim_plugin_dir . '/coc.nvim')
    " key mappings
    " --------------------------------------
    " <TAB> completion mapping + helper function
    inoremap <silent> <expr><TAB>
                \ pumvisible() ? '<C-n>' :
                \ <SID>check_back_space() ? '<TAB>' :
                \ coc#refresh()

    " use <CR> to confirm completion (<C-g>u means break undo chain at current position)
    if exists('*complete_info')
      inoremap <expr> <CR> complete_info()['selected'] != '-1' ? '<C-y>' : '<C-g>u<CR>'
    else
      inoremap <expr> <CR> pumvisible() ? '<C-y>' : '<C-g>u<CR>'
    endif

    " trigger completion
    inoremap <silent><expr> <C-space> coc#refresh()

    " show type info and short doc for identifier under cursor
    nnoremap <silent> <leader>sd
                \ :call <SID>show_documentation()<CR>

    " goto definition under cursor
    nnoremap <silent> gd
                \ :call <SID>go_to_definition()<CR>

    " goto type definition under cursor
    nnoremap <silent> gtd
                \ :call CocActionAsync('jumpTypeDefinition')<CR>

    " goto reference of identifier under cursor
    " opens a list if multiple are available
    nnoremap <silent> gr
                \ :call CocActionAsync('jumpReferences')<CR>

    " rename object under cursor for the whole project
    nnoremap <silent> <leader>rn
                \ :call CocActionAsync('rename')<CR>

    " list of current document symbols
    nnoremap <silent> <leader>ld :CocList outline<CR>

    " search interactive in workspace symbols
    nnoremap <silent> <leader>lw :CocList symbols<CR>

    " user commands
    " --------------------------------------
    if !exists(':ToggleCocHighlight')
        command -nargs=0 ToggleCocHighlight :call <SID>coc_highlight(1)
    endif

    " autocommands
    " --------------------------------------
    augroup coc_related
        autocmd!
        " update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        " configure coc on vim enter if it is loaded
        autocmd VimEnter * if exists('g:did_coc_loaded') | call s:coc_config() | endif
    augroup END

    " functions
    " --------------------------------------
    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1] =~# '\s'
    endfunction

    function! s:show_documentation()
        " for vim use the internal help
        if (index(['vim', 'help'], &filetype) >= 0)
            execute 'help ' . expand('<cword>')
        else
            call CocActionAsync('doHover')
        endif
    endfunction

    function! s:go_to_definition()
        let ret = execute('call CocAction("jumpDefinition")', 'silent!')
        if ret =~# 'not found'
            " TODO: why are only double quotes working here?
            execute("silent! normal \<C-]>")
        endif
    endfunction

    function! s:coc_highlight(...)
        if !exists('g:toggle_coc_highlight')
            let g:toggle_coc_highlight = 1
        endif

        " for toggle behavior
        if a:0 == 1
            let g:toggle_coc_highlight = 1 - g:toggle_coc_highlight

            if g:toggle_coc_highlight == 0
                echomsg 'coc: symbol highlight [enabled]'
                augroup coc_highlight
                    autocmd!
                    " highlight symbol under cursor on cursor hold
                    autocmd CursorHold * silent call CocActionAsync('highlight')
                augroup END
            else
                echomsg 'coc: symbol highlight [enabled]'
                autocmd! coc_highlight
            endif
        endif
    endfunction

    function! s:coc_config() abort
        call coc#config('coc.preferences',
                    \ {
                    \   'extensionUpdateCheck': 'never',
                    \   'snippets.enable': v:false,
                    \   'formatOnSaveFiletypes': ['rust'],
                    \ })

        call coc#config('coc.source',
                    \ {
                    \   'around.shortcut': 'around',
                    \   'buffer.shortcut': 'buffer',
                    \
                    \   'file.shortcut': 'path',
                    \   'file.ignoreHidden': v:false,
                    \
                    \   'issues.enable': v:false,
                    \ })

        call coc#config('suggest',
                    \ {
                    \   'floatEnable': v:false,
                    \
                    \   'labelMaxLength': 55,
                    \   'detailMaxLength': 30,
                    \   'detailField': 'menu',
                    \
                    \   'snippetIndicator': '',
                    \   'fixInsertedWord': v:false,
                    \ })

        call coc#config('suggest.completionItemKindLabels',
                    \ {
                    \   'text': 'text',
                    \   'method': 'method',
                    \   'function': 'function',
                    \   'constructor': 'constructor',
                    \   'field': 'field',
                    \   'variable': 'variable',
                    \   'class': 'class',
                    \   'interface': 'interface',
                    \   'module': 'module',
                    \   'property': 'property',
                    \   'unit': 'unit',
                    \   'value': 'value',
                    \   'enum': 'enum',
                    \   'keyword': 'keyword',
                    \   'snippet': 'snippet',
                    \   'color': 'color',
                    \   'file': 'file',
                    \   'reference': 'reference',
                    \   'folder': 'folder',
                    \   'enumMember': 'enumMember',
                    \   'constant': 'constant',
                    \   'struct': 'struct',
                    \   'event': 'event',
                    \   'operator': 'operator',
                    \   'typeParameter': 'typeParameter',
                    \   'default': 'default',
                    \ })

        call coc#config('diagnostic',
                    \ {
                    \   'messageTarget': 'echo',
                    \   'refreshOnInsertMode': v:true,
                    \   'enableHighlightLineNumber': v:false,
                    \
                    \   'infoSign': '●',
                    \   'hintSign': '●',
                    \   'errorSign': '●',
                    \   'warningSign': '●',
                    \
                    \   'virtualText': v:true,
                    \   'virtualTextLines': 1,
                    \   'virtualTextPrefix': '> ',
                    \ })

        call coc#config('signature',
                    \ {
                    \   'floatMaxWidth': 100,
                    \   'maxWindowHeight': 10,
                    \   'triggerSignatureWait': 200,
                    \ })

        call coc#config('codeLens',
                    \ {
                    \   'enable': v:false,
                    \   'separator': '>',
                    \ })
    endfunction
endif

" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
