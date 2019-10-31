" define keywords/regions/matches
" --------------------------------------
syntax keyword pythonCls cls
syntax keyword pythonSelf self
syntax keyword pythonLambda lambda

syntax match pythonCustomFunc "\<\w\+\ze("
syntax match pythonDecoratorFunc "\%(\%(@\)\s*\)\@<=\h\%(\w\|\.\)*" contained
syntax match pythonDecorator "@" display nextgroup=pythonDecoratorFunc skipwhite

syntax region pythonFVariable start=+{+ end=+}+ contained
syntax region pythonFString matchgroup=pythonQuotes start=+f\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
            \ contains=pythonFVariable,pythonEscape,@Spell

syntax region pythonDocstring start=+^\s*[uU]\?[rR]\?"""+ end=+"""+ keepend excludenl
            \ contains=pythonEscape,@Spell,pythonDoctest,pythonSpaceError
syntax region pythonDocstring start=+^\s*[uU]\?[rR]\?'''+ end=+'''+ keepend excludenl
            \ contains=pythonEscape,@Spell,pythonDoctest,pythonSpaceError

" define highlight links
" --------------------------------------
highlight default link pythonFString    String
highlight default link pythonFVariable  Operator
highlight default link pythonCustomFunc Function

highlight default link pythonCls        Keyword
highlight default link pythonSelf       Keyword
highlight default link pythonLambda     Keyword
highlight default link pythonDocstring  Comment
