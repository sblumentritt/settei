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
    command -buffer -nargs=0 ClassSkeleton :call <SID>object_skeleton("class")
endif

if !exists(':StructSkeleton')
    command -buffer -nargs=0 StructSkeleton :call <SID>object_skeleton("struct")
endif

" helper functions
" --------------------------------------
" generate a modern C++ object skeleton
if !exists('*s:object_skeleton')
    function s:object_skeleton(base)
        let l:object = input('Enter object name: ', '')
        if !empty(l:object)
            let l:object_skeleton =
                        \ [
                        \   '',
                        \   '/// TODO: document the ' . a:base,
                        \   a:base . ' ' . l:object . ' {',
                        \ ]

            if a:base == "class"
                call add(l:object_skeleton, 'public:')
            endif

            call extend(l:object_skeleton,
                        \ [
                        \   '    /// Constructor.',
                        \   '    ' . l:object . '() = default;',
                        \   '    /// Destructor.',
                        \   '    ~' . l:object . '() noexcept = default;',
                        \   '',
                        \   '    /// Copy constructor.',
                        \   '    ' . l:object . '(' . l:object . ' const& other) = default;',
                        \   '    /// Copy assignment.',
                        \   '    auto operator=(' . l:object . ' const& other) -> ' . l:object . '& = default;',
                        \   '',
                        \   '    /// Move constructor.',
                        \   '    ' . l:object . '(' . l:object . '&& other) noexcept = default;',
                        \   '    /// Move assignment.',
                        \   '    auto operator=(' . l:object . '&& other) noexcept -> ' . l:object . '& = default;',
                        \   '};',
                        \ ])
            call append(line('.'), l:object_skeleton)
        endif
    endfunction
endif

" cleanup
" --------------------------------------
" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
