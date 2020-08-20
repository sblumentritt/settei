" define keywords/regions/matches
" --------------------------------------
syntax keyword cppThrow throw
syntax keyword cppDelete delete
syntax keyword cppBool true false
syntax keyword cppNullptr nullptr
syntax keyword cppStructs class typename template namespace
syntax keyword cppSpecifier constexpr decltype final noexcept
syntax keyword cppSpecifier inline virtual explicit export override

syntax match cppAttribute "\[\[.*\]\]" contains=cString

" classes should follow 'CamelCase'
syntax match cppCustomClass "\<\u\(\l\|\u\l\)\+\>"

syntax match cppCustomScope "::" contained
syntax match cppScopeEnd "::\w\+"
            \ contains=cppCustomScope,cCustomEnumerator,cType
            \ containedin=cppCustomClass
syntax match cppScopeFront "\w\+\ze::" contains=cppCustomScope
            \ containedin=cppCustomClass

" standard template function naming style (lowercase start and mixed)
syntax match cppCustomTemplateFunc "\<[a-z][a-zA-Z0-9_]\+\ze<.*>("
            \ containedin=cppScopeEnd,cppCustomClass

" define highlight links
" --------------------------------------
highlight default link cppBool        Identifier
highlight default link cppDelete      Exception
highlight default link cppThrow       Exception
highlight default link cppExcept      StorageClass
highlight default link cppNullptr     Identifier
highlight default link cppStructs     Structure
highlight default link cppAttribute   Constant
highlight default link cppSpecifier   StorageClass

highlight default link cppScopeEnd    Statement
highlight default link cppScopeFront  Statement

highlight default link cppCustomScope Operator
highlight default link cppCustomClass Typedef

highlight default link cppCustomTemplateFunc Function
