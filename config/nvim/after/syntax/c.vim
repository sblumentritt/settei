" define keywords/regions/matches
" --------------------------------------
syntax match cCustomOperator "/$"
syntax match cCustomOperator "&&\|||"
syntax match cCustomOperator "[.!~*&%<>^|]"
syntax match cCustomOperator "/[^/*=]"me=e-1
syntax match cCustomOperator "\(<<\|>>\|[*/%&^|<>!]\)="
syntax match cCustomOperator "<<\|>>\|&&\|||\|++\|--\|->"

syntax keyword cConstant TRUE FALSE

syntax match cCustomInternal "\<__\w\+"

" enumerators following personal naming convention
syntax match cCustomEnumerator "\<e_[a-zA-Z0-9_]\+\>"

" global variables following personal naming convention
syntax match cCustomGlobalVariable "\<g_[a-zA-Z0-9_]\+\>"

" bad naming style used for defines/typedefs/etc.
syntax match cCustomBadName "\<[A-Z][a-zA-Z0-9_]\+\>"

" standard macro naming style (uppercase)
syntax match cCustomMacro "\<[A-Z_][A-Z0-9_]\+\>"

" bad function naming style (uppercase start and CamelCase)
syntax match cCustomBadFunc "\<[A-Z][a-zA-Z0-9_]\+\ze("
            \ containedin=cppScopeEnd,cppCustomClass

" standard function naming style (lowercase start and mixed)
syntax match cCustomFunc "\<[a-z][a-zA-Z0-9_]\+\ze("
            \ containedin=cppScopeEnd,cppCustomClass

" standard define function naming style (uppercase)
syntax match cCustomDefineFunc "\<[A-Z0-9_]\+\ze("
            \ containedin=cppScopeEnd,cppCustomClass

" find function parameter in doxygen comments
syntax match cCustomDoxyElement "\v\\(param(|\s?\[[in,out]+\])|tparam)\s+\zs\w+"
            \ containedin=cComment,cCommentL

" only highlight numbers and operators in defines and not functions
syntax region cCustomDefine start="^\s*\(%:\|#\)\s*\(define\|undef\)\>"
            \ skip="\\$" end="$" keepend contains=cNumber,cOperator,cCustomOperator

" define highlight links
" --------------------------------------
highlight default link cCustomOperator   Operator
highlight default link cCustomFunc       Function
highlight default link cCustomBadFunc    Function
highlight default link cCustomInternal   Constant

highlight default link cCustomMacro      Macro
highlight default link cCustomDefine     Define
highlight default link cCustomBadName    Macro
highlight default link cCustomDefineFunc Define

highlight default link cCustomEnumerator     Type
highlight default link cCustomGlobalVariable Delimiter
