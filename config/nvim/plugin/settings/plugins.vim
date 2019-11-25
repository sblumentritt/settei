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

" rust.vim configurations
" --------------------------------------
let g:rust_fold = 0
let g:rust_conceal = 0
let g:rustfmt_autosave = 0
let g:rust_recommended_style = 1

" lsp-cxx-highlight configurations
" --------------------------------------
let g:lsp_cxx_hl_use_nvim_text_props = 0
let g:lsp_cxx_hl_ft_whitelist = ['c', 'cpp']

" vim-clang-format configurations
" --------------------------------------
let g:clang_format#auto_format = 1
let g:clang_format#code_style = 'llvm'
let g:clang_format#detect_style_file = 1
let g:clang_format#enable_fallback_style = 0
let g:clang_format#auto_format_on_insert_leave = 0

augroup clang_format_settings
    autocmd!
    autocmd FileType c,cpp vnoremap <buffer> <Leader>f :ClangFormat<CR>
    autocmd FileType c,cpp nnoremap <buffer> <Leader>f :<C-u>ClangFormat<CR>

    autocmd FileType c,cpp nmap <buffer> <F12> :ClangFormatAutoToggle<CR>
augroup END

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

" nvim-colorizer.lua configurations
" --------------------------------------
if isdirectory($neovim_plugin_dir . '/nvim-colorizer.lua')
    " disable auto highlight and configure options
    lua require('colorizer').setup({'!*';}, {RRGGBBAA = true; css = true;})

    " mapping to toggle color highlighting in current buffer
    nnoremap <leader>tc :call <SID>toggle_color_highlight()<CR>

    function! s:toggle_color_highlight()
        if !exists('b:enable_color_highlight')
            let b:enable_color_highlight = 1
        else
            let b:enable_color_highlight = 1 - b:enable_color_highlight
        endif

        if b:enable_color_highlight == 1
            lua require('colorizer').attach_to_buffer(0)
            echomsg 'nvim-colorizer: highlighting [enabled]'
        else
            lua require('colorizer').detach_from_buffer(0)
            echomsg 'nvim-colorizer: highlighting [disabled]'
        endif
    endfunction
endif

" vim-markdown configurations
" --------------------------------------
let g:markdown_syntax_conceal = 0
let g:markdown_fenced_languages = [
            \ 'cmake', 'c', 'cpp', 'vim', 'sh', 'rust',
            \ 'viml=vim', 'bash=sh'
            \ ]

" markdown-preview configurations
" --------------------------------------
let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 1
let g:mkdp_page_title = '[ ${name} ]'

" fzf configurations
" --------------------------------------
let g:fzf_buffers_jump = 1
let g:fzf_layout = {'down': '~25%'}

" override default Rg implementation to include hidden files
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always'
            \   . ' --smart-case --hidden --glob "!.git" '
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

" vim-mergetool configurations
" --------------------------------------
let g:mergetool_layout = 'l,m,r'
let g:mergetool_prefer_revision = 'base'

" custom keybindings for merge
nmap <expr> <A-Up> &diff ? '<Plug>(MergetoolDiffExchangeUp)' : '<A-Up>'
nmap <expr> <A-Down> &diff ? '<Plug>(MergetoolDiffExchangeDown)' : '<A-Down>'
nmap <expr> <A-Left> &diff ? '<Plug>(MergetoolDiffExchangeLeft)' : '<A-Left>'
nmap <expr> <A-Right> &diff ? '<Plug>(MergetoolDiffExchangeRight)' : '<A-Right>'

" undotree configurations
" --------------------------------------
let g:undotree_HelpLine = 0
let g:undotree_SplitWidth = 35
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 15
let g:undotree_SetFocusWhenToggle = 1

" doxygentoolkit configurations
" --------------------------------------
let g:DoxygenToolkit_compactDoc = 'no'
let g:DoxygenToolkit_commentType = 'C++'
let g:DoxygenToolkit_compactOneLineDoc = 'yes'

" change tag style to latex instead of javadoc
let g:DoxygenToolkit_briefTag_pre = ''
let g:DoxygenToolkit_fileTag = '\file '
let g:DoxygenToolkit_dateTag = '\date '
let g:DoxygenToolkit_blockTag = '\name '
let g:DoxygenToolkit_classTag = '\class '
let g:DoxygenToolkit_authorTag = '\author '
let g:DoxygenToolkit_returnTag = '\returns '
let g:DoxygenToolkit_versionTag = '\version '
let g:DoxygenToolkit_paramTag_pre = '\param '
let g:DoxygenToolkit_throwTag_pre = '\throw '
let g:DoxygenToolkit_templateParamTag_pre = '\tparam '

" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
