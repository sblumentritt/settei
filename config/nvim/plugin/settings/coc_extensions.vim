" --------------------------------------
" coc configurations
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_coc_extensions_settings')
    finish
endif
let g:loaded_coc_extensions_settings = 1

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" check if plugin is available
if isdirectory($neovim_plugin_dir . '/coc.nvim')
    " autocommands
    " --------------------------------------
    augroup coc_extensions_related
        autocmd!
        " configure coc extensions on vim enter if it is loaded
        autocmd VimEnter * if exists('g:did_coc_loaded') | call s:coc_extensions_config() | endif
    augroup END

    " functions
    " --------------------------------------
    function! s:coc_extensions_config() abort
        " coc extensions
        " --------------------------------------
        call coc#add_extension('coc-vimlsp')
        call coc#add_extension('coc-diagnostic')

        " config for coc-diagnostic extension
        call coc#config('diagnostic-languageserver.filetypes',
                    \ {
                    \   'c': 'cppcheck',
                    \   'cpp': ['cppcheck', 'clang-tidy'],
                    \   'sh': 'shellcheck',
                    \ })

        " coc-diagnostic linter configurations
        let l:linters = {}

        let l:gcc_format_pattern =
                    \ [
                    \   "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
                    \   {
                    \       'line': 1,
                    \       'column': 2,
                    \       'message': 4,
                    \       'security': 3
                    \   }
                    \ ]

        if executable('shellcheck')
            let l:linters['shellcheck'] =
                        \ {
                        \   'command': 'shellcheck',
                        \   'sourceName': 'shellcheck',
                        \   'debounce': 100,
                        \
                        \   'args':
                        \   [
                        \       '--format=gcc',
                        \       '--exclude=SC1090,SC1094,SC2155,SC2086,SC2032,SC2033',
                        \       '--shell=dash',
                        \       '-x',
                        \       '-',
                        \   ],
                        \
                        \   'offsetLine': 0,
                        \   'offsetColumn': 0,
                        \   'formatLines': 1,
                        \   'formatPattern': l:gcc_format_pattern,
                        \   'securities':
                        \   {
                        \       'note': 'info',
                        \       'error': 'error',
                        \       'warning': 'warning',
                        \   }
                        \ }
        endif

        if executable('cppcheck')
            let l:linters['cppcheck'] =
                        \ {
                        \   'command': 'cppcheck',
                        \   'sourceName': 'cppcheck',
                        \   'debounce': 100,
                        \   'isStderr': v:true,
                        \
                        \   'args':
                        \   [
                        \       '--quiet',
                        \       '--platform=unix64',
                        \       '--template={line}:{column}:{severity}:{message}',
                        \       '--enable=warning,performance,portability,style,information',
                        \       '--suppress=syntaxError',
                        \       '--suppress=passedByValue',
                        \       '--suppress=missingInclude',
                        \       '--suppress=unusedStructMember',
                        \       '--suppress=unmatchedSuppression',
                        \       '--suppress=missingIncludeSystem',
                        \       '%file',
                        \   ],
                        \
                        \   'offsetLine': 0,
                        \   'offsetColumn': 0,
                        \   'formatLines': 1,
                        \   'formatPattern':
                        \   [
                        \       "^(\\d+):(\\d+):([^:]+):(.*)$",
                        \       {
                        \           'line': 1,
                        \           'column': 2,
                        \           'message': 4,
                        \           'security': 3
                        \       }
                        \   ],
                        \   'securities':
                        \   {
                        \       'style': 'info',
                        \       'error': 'error',
                        \       'warning': 'warning',
                        \   }
                        \ }
        endif

        if executable('clang-tidy')
            let l:clang_tidy_checks =
                        \ [
                        \   '-*',
                        \
                        \   'bugprone-*',
                        \   'cppcoreguidelines-narrowing-conversions',
                        \   'cppcoreguidelines-pro-type-cstyle-cast',
                        \   'cppcoreguidelines-pro-type-member-init',
                        \   'cppcoreguidelines-pro-type-static-cast-downcast',
                        \   'cppcoreguidelines-special-member-functions',
                        \   'misc-*',
                        \   'modernize-*',
                        \   'performance-*',
                        \   'readability-*',
                        \
                        \   '-clang-analyzer-*',
                        \   '-clang-diagnostic-*',
                        \   '-readability-magic-numbers',
                        \   '-readability-convert-member-functions-to-static',
                        \ ]


            let l:linters['clang-tidy'] =
                        \ {
                        \   'command': 'clang-tidy',
                        \   'sourceName': 'clang-tidy',
                        \   'debounce': 100,
                        \
                        \   'rootPatterns':
                        \   [
                        \       'CMakeLists.txt',
                        \       'README.md',
                        \       '.clang-tidy'
                        \   ],
                        \
                        \   'args':
                        \   [
                        \       '--checks=' . join(l:clang_tidy_checks, ','),
                        \       '--quiet',
                        \       '%file',
                        \   ],
                        \
                        \   'offsetLine': 0,
                        \   'offsetColumn': 0,
                        \   'formatLines': 1,
                        \   'formatPattern': l:gcc_format_pattern,
                        \   'securities':
                        \   {
                        \       'error': 'error',
                        \       'warning': 'warning',
                        \   }
                        \ }
        endif

        if !empty(l:linters)
            call coc#config('diagnostic-languageserver.linters', l:linters)
        endif
   endfunction
endif

" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
