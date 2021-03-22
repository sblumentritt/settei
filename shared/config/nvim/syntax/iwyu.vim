" --------------------------------------
" iwyu syntax highlighting
" --------------------------------------
" avoid loading syntax twice
if exists('b:current_syntax')
    finish
endif

" save old value of cpoptions and allow line-continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" define keywords/regions/matches
" --------------------------------------
" matching case
syntax case match

syn match iwyuRemoved "^- .*"
syn match iwyuSectionSeparator "^---"

syn region iwyuIncluded	display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match iwyuIncluded display contained "<[^>]*>"
syn match iwyuInclude display "^\s*\zs\(%:\|#\)\s*include\>\s*["<]" contains=iwyuIncluded

syn region iwyuComment start="//" skip="\\$" end="$" keepend contains=@Spell

syn keyword iwyuStructure class struct typename template namespace
syntax match iwyuClass "\<\u\(\l\|\u\l\)\+\>"
" bad naming style used for defines/typedefs/etc.
syntax match iwyuBadName "\<[A-Z][a-zA-Z0-9_]\+\>"

syntax match iwyuScope "::" contained
syntax match iwyuScopeEnd "::\w\+"
            \ contains=iwyuScope
            \ containedin=iwyuClass
syntax match iwyuScopeFront "\w\+\ze::" contains=iwyuScope
            \ containedin=iwyuClass


" define highlight links
" --------------------------------------
highlight default link iwyuString String
highlight default link iwyuRemoved Exception
highlight default link iwyuIncluded String
highlight default link iwyuInclude PreProc
highlight default link iwyuComment Comment
highlight default link iwyuSectionSeparator Comment
highlight default link iwyuStructure Identifier
highlight default link iwyuScope Operator
highlight default link iwyuScopeEnd Identifier
highlight default link iwyuScopeFront Identifier
highlight default link iwyuClass Identifier
highlight default link iwyuBadName Identifier

" cleanup
" --------------------------------------
let b:current_syntax = 'iwyu'

" restore old value of cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo
