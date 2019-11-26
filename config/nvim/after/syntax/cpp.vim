" define keywords/regions/matches
" --------------------------------------
syntax keyword cppThrow throw
syntax keyword cppDelete delete
syntax keyword cppBool true false
syntax keyword cppNullptr nullptr
syntax keyword cppStructs class typename template namespace
syntax keyword cppSpecifier constexpr decltype final noexcept
syntax keyword cppSpecifier inline virtual explicit export override

syntax region cppAttribute start=+\[\[+ end=+\]\]+

" classes should follow 'CamelCase'
syntax match cppCustomClass "\<\u\(\l\|\u\l\)\+\>"

syntax match cppCustomScope "::" contained
syntax match cppScopeEnd "::\w\+"
            \ contains=cppCustomScope,cCustomEnumerator,cType
            \ containedin=cppCustomClass
syntax match cppScopeFront "\w\+\ze::" contains=cppCustomScope
            \ containedin=cppCustomClass

" define highlight links
" --------------------------------------
highlight default link cppBool        Identifier
highlight default link cppDelete      Exception
highlight default link cppThrow       Exception
highlight default link cppExcept      StorageClass
highlight default link cppNullptr     Identifier
highlight default link cppStructs     Identifier
highlight default link cppAttribute   Constant
highlight default link cppSpecifier   StorageClass

highlight default link cppScopeEnd    Identifier
highlight default link cppScopeFront  Identifier

highlight default link cppCustomScope Operator
highlight default link cppCustomClass Identifier
