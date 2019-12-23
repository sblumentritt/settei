" --------------------------------------
" cpp filetype configurations
" --------------------------------------
" avoid executing the plugin twice
if exists('b:did_ftplugin')
    finish
endif

" behave like a c file
" NOTE: only source the first file found
runtime ftplugin/c.vim

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" user commands
" --------------------------------------
if !exists(':ClassSkeleton')
    command -buffer -nargs=0 ClassSkeleton :call <SID>class_skeleton()
endif

" helper functions
" --------------------------------------
" generate a modern c++ class skeleton for header files
if !exists('*s:class_skeleton')
    function s:class_skeleton()
        if expand('%:e') ==# 'h' || expand('%:e') ==# 'hpp'
            let l:class = input('Enter class name: ', '')
            if !empty(l:class)
                let class_skeleton =
                            \[
                            \ '',
                            \ '/// TODO: document the class',
                            \ 'class ' . l:class . ' {',
                            \ 'public:',
                            \ '    /// Constructor.',
                            \ '    ' . l:class . '() = default;',
                            \ '    /// Destructor.',
                            \ '    ~' . l:class . '() noexcept = default;',
                            \ '',
                            \ '    /// Copy constructor.',
                            \ '    ' . l:class . '(' . l:class . ' const& other) = default;',
                            \ '    /// Copy assignment.',
                            \ '    auto operator=(' . l:class . ' const& other) -> ' . l:class . '& = default;',
                            \ '',
                            \ '    /// Move constructor.',
                            \ '    ' . l:class . '(' . l:class . '&& other) noexcept = default;',
                            \ '    /// Move assignment.',
                            \ '    auto operator=(' . l:class . '&& other) noexcept -> ' . l:class . '& = default;',
                            \ '};',
                            \]
                call append(line('.'), class_skeleton)
            endif
        endif
    endfunction
endif

" cleanup
" --------------------------------------
" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
