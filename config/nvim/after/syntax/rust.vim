" define keywords/regions/matches
" --------------------------------------
syntax keyword rustSpecialKeyword break continue return yield

" highlight formatting placeholder '{}' in strings
syntax region rustFormatElement start=+{+ end=+}+ contained

syntax region rustString matchgroup=rustStringDelimiter start=+b"+ skip=+\\\\\|\\"+ end=+"+
            \ contains=rustFormatElement,rustEscape,rustEscapeError,rustStringContinuation
syntax region rustString matchgroup=rustStringDelimiter start=+"+ skip=+\\\\\|\\"+ end=+"+
            \ contains=rustFormatElement,rustEscape,rustEscapeUnicode,rustEscapeError,rustStringContinuation,@Spell
syntax region rustString matchgroup=rustStringDelimiter start='b\?r\z(#*\)"' end='"\z1'
            \ contains=rustFormatElement,@Spell

" define highlight links
" --------------------------------------
highlight default link rustSpecialKeyword Exception
highlight default link rustFormatElement Operator
