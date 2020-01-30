" --------------------------------------
" custom colorscheme
" --------------------------------------
set background=dark
highlight! clear

if exists('syntax_on')
    syntax reset
endif

" 進 -> progressing
let g:colors_name='susumu'

" definition of color palette
" --------------------------------------
let s:colors = {}

let s:colors.dark_gray = ['#3c3a3a', '0']
let s:colors.red       = ['#ef6851', '1']
let s:colors.green     = ['#c8bb5b', '2']
let s:colors.orange    = ['#faa055', '3']
let s:colors.blue      = ['#82c1a8', '4']
let s:colors.magenta   = ['#d3879c', '5']
let s:colors.cyan      = ['#9fca8f', '6']
let s:colors.bwhite    = ['#ebe2d3', '7']

let s:colors.gray      = ['#9d8f81', '8']
let s:colors.yellow    = ['#fcbd5e', '11']
let s:colors.white     = ['#f2e7c5', '15']

let s:colors.bg   = ['#1d2021', '0']
let s:colors.none = ['none', 'none']

" helper function
" --------------------------------------
function! s:highlight(group, fg, ...)
    " additional arguments: bg, style

    let l:highlight_string = 'highlight ' . a:group . ' '

    let l:highlight_string .= 'guifg=' . a:fg[0] . ' '
    let l:highlight_string .= 'ctermfg=' . a:fg[1] . ' '

    if a:0 >= 1
        let l:highlight_string .= 'guibg=' . a:1[0] . ' '
        let l:highlight_string .= 'ctermbg=' . a:1[1] . ' '
    else
        let l:highlight_string .= 'guibg=' . s:colors.none[0] . ' '
        let l:highlight_string .= 'ctermbg=' . s:colors.none[1] . ' '
    endif

    if a:0 >= 2
        let l:highlight_string .= 'gui=' . a:2 . ' '
        let l:highlight_string .= 'cterm=' . a:2 . ' '
    else
        let l:highlight_string .= 'gui=' . s:colors.none[0] . ' '
        let l:highlight_string .= 'cterm=' . s:colors.none[1] . ' '
    endif

    execute l:highlight_string
endfunction

" generic syntax (see :help group-name)
" --------------------------------------
call s:highlight('Comment', s:colors.gray)
call s:highlight('Number', s:colors.yellow)
call s:highlight('Float', s:colors.yellow)
call s:highlight('Constant', s:colors.magenta)
call s:highlight('String', s:colors.green)
call s:highlight('Character', s:colors.green)
call s:highlight('Boolean', s:colors.orange)
call s:highlight('Identifier', s:colors.blue)
call s:highlight('Function', s:colors.cyan)
call s:highlight('Statement', s:colors.blue)
call s:highlight('Conditional', s:colors.blue)
call s:highlight('Repeat', s:colors.blue)
call s:highlight('Operator', s:colors.white)
call s:highlight('Keyword', s:colors.orange)
call s:highlight('Label', s:colors.blue)
call s:highlight('Exception', s:colors.red)
call s:highlight('PreProc', s:colors.magenta)
call s:highlight('Include', s:colors.magenta)
call s:highlight('Define', s:colors.magenta)
call s:highlight('Macro', s:colors.magenta)
call s:highlight('PreCondit', s:colors.magenta)
call s:highlight('Type', s:colors.yellow)
call s:highlight('StorageClass', s:colors.orange, s:colors.none, 'italic')
call s:highlight('Structure', s:colors.orange)
call s:highlight('Typedef', s:colors.yellow)
call s:highlight('Special', s:colors.white)
call s:highlight('SpecialChar', s:colors.orange)
call s:highlight('SpecialComment', s:colors.gray, s:colors.none, 'italic')
call s:highlight('Delimiter', s:colors.white, s:colors.none, 'bold')
call s:highlight('Underlined', s:colors.blue, s:colors.none, 'underline')
call s:highlight('Ignore', s:colors.gray)
call s:highlight('Error', s:colors.bg, s:colors.red, 'bold')
call s:highlight('Todo', s:colors.gray, s:colors.none, 'bold')
call s:highlight('Debug', s:colors.gray, s:colors.none, 'italic')

" vim ui (see :help highlight-groups)
" --------------------------------------
call s:highlight('Title', s:colors.blue)
call s:highlight('ColorColumn', s:colors.white, s:colors.dark_gray)
call s:highlight('CursorColumn', s:colors.white)
call s:highlight('CursorLine', s:colors.none, s:colors.dark_gray)
call s:highlight('Directory', s:colors.blue)
call s:highlight('DiffAdd', s:colors.green)
call s:highlight('DiffDelete', s:colors.red)
call s:highlight('DiffChange', s:colors.orange)
call s:highlight('DiffText', s:colors.none, s:colors.none, 'bold')
call s:highlight('ErrorMsg', s:colors.red, s:colors.none, 'bold')
call s:highlight('WarningMsg', s:colors.orange, s:colors.none, 'bold')
call s:highlight('VertSplit', s:colors.dark_gray)
call s:highlight('Folded', s:colors.gray, s:colors.none, 'italic')
call s:highlight('FoldColumn', s:colors.white)
call s:highlight('SignColumn', s:colors.white)
call s:highlight('LineNr', s:colors.gray)
call s:highlight('CursorLineNr', s:colors.white, s:colors.none, 'bold')
call s:highlight('MatchParen', s:colors.orange)
call s:highlight('ModeMsg', s:colors.white)
call s:highlight('MoreMsg', s:colors.green)
call s:highlight('NonText', s:colors.white)
call s:highlight('EndOfBuffer', s:colors.dark_gray)
call s:highlight('Normal', s:colors.white)
call s:highlight('NormalFloat', s:colors.white, s:colors.dark_gray)
call s:highlight('Pmenu', s:colors.white, s:colors.dark_gray)
call s:highlight('PmenuSel', s:colors.dark_gray, s:colors.blue, 'bold')
call s:highlight('PmenuSbar', s:colors.gray, s:colors.dark_gray)
call s:highlight('PmenuThumb', s:colors.gray, s:colors.dark_gray)
call s:highlight('Question', s:colors.yellow)
call s:highlight('QuickFixLine', s:colors.none, s:colors.dark_gray)
call s:highlight('Search', s:colors.orange, s:colors.none, 'underline,bold')
call s:highlight('IncSearch', s:colors.orange, s:colors.none, 'underline,bold')
call s:highlight('SpecialKey', s:colors.none)
call s:highlight('SpellBad', s:colors.red, s:colors.none, 'underline,italic')
call s:highlight('SpellCap', s:colors.magenta, s:colors.none, 'underline,italic')
call s:highlight('SpellLocal', s:colors.cyan, s:colors.none, 'underline,italic')
call s:highlight('SpellRare', s:colors.blue, s:colors.none, 'underline,italic')
call s:highlight('StatusLine', s:colors.white)
call s:highlight('StatusLineNC', s:colors.gray)
call s:highlight('TabLine', s:colors.white, s:colors.dark_gray)
call s:highlight('TabLineFill', s:colors.white, s:colors.dark_gray)
call s:highlight('TabLineSel', s:colors.orange)
call s:highlight('Visual', s:colors.none, s:colors.dark_gray)
call s:highlight('WildMenu', s:colors.orange)

" for custom statusline
" --------------------------------------
call s:highlight('ModeStatusNormal', s:colors.bg, s:colors.gray)
call s:highlight('ModeStatusInsert', s:colors.bg, s:colors.blue)
call s:highlight('ModeStatusVisual', s:colors.bg, s:colors.orange)
call s:highlight('ModeStatusReplace', s:colors.bg, s:colors.cyan)
call s:highlight('ModeStatusCommand', s:colors.bg, s:colors.yellow)
call s:highlight('ModeStatusTerminal', s:colors.bg, s:colors.magenta)

call s:highlight('DiagnosticStatusOk', s:colors.bg, s:colors.gray)
call s:highlight('DiagnosticStatusError', s:colors.bg, s:colors.red)
call s:highlight('DiagnosticStatusWarning', s:colors.bg, s:colors.orange)

call s:highlight('StatusLayerOne', s:colors.white, s:colors.dark_gray)
call s:highlight('StatusLayerTwo', s:colors.white)

call s:highlight('StatusLayerOneInactive', s:colors.gray, s:colors.dark_gray)
call s:highlight('StatusLayerTwoInactive', s:colors.gray)

" define better colors for makefile
" --------------------------------------
call s:highlight('makeIdent', s:colors.blue)
call s:highlight('makeCommands', s:colors.white)

" define better colors for c/c++
" --------------------------------------
call s:highlight('cppThrow', s:colors.red)
call s:highlight('cppDelete', s:colors.red)
call s:highlight('cFormat', s:colors.orange)
call s:highlight('cSpecial', s:colors.white)
call s:highlight('cStatement', s:colors.red)
call s:highlight('cCustomDoxyElement', s:colors.gray, s:colors.none, 'bold')
call s:highlight('cCustomGlobalVariable', s:colors.white, s:colors.none, 'italic')

" define better colors for cmake
" --------------------------------------
call s:highlight('cmakeKWif', s:colors.yellow)
call s:highlight('cmakeVariable', s:colors.blue)
call s:highlight('cmakeVariableValue', s:colors.blue)
call s:highlight('cmakeGeneratorExpression', s:colors.magenta)
call s:highlight('cmakeGeneratorExpressions', s:colors.orange)

" define better colors for shell
" --------------------------------------
call s:highlight('shAlias', s:colors.white)
call s:highlight('shSetList', s:colors.white)
call s:highlight('shCommandsSub', s:colors.white)

" define better colors for python
" --------------------------------------
call s:highlight('pythonDecorator', s:colors.blue, s:colors.none, 'italic')
call s:highlight('pythonDecoratorFunc', s:colors.blue, s:colors.none, 'italic')

" define better colors for diff
" --------------------------------------
call s:highlight('diffLine', s:colors.cyan)
call s:highlight('diffAdded', s:colors.green)
call s:highlight('diffRemoved', s:colors.red)
call s:highlight('diffFile', s:colors.bwhite, s:colors.none, 'bold')
call s:highlight('diffIndexLine', s:colors.bwhite, s:colors.none, 'bold')

" define better colors for man pages
" --------------------------------------
call s:highlight('manOptionDesc', s:colors.cyan)
call s:highlight('manReference', s:colors.magenta)
call s:highlight('manUnderline', s:colors.none, s:colors.none, 'italic')

" define better colors for vim
" --------------------------------------
call s:highlight('vimSep', s:colors.white)
call s:highlight('vimGroup', s:colors.yellow)
call s:highlight('vimBracket', s:colors.white)
call s:highlight('vimParenSep', s:colors.white)
call s:highlight('vimGroupName', s:colors.cyan)
call s:highlight('vimSpecial', s:colors.orange)
call s:highlight('vimCommentTitle', s:colors.gray, s:colors.none, 'bold')

" define better colors for markdown
" --------------------------------------
call s:highlight('markdownError', s:colors.red)
call s:highlight('markdownItalic', s:colors.white, s:colors.none, 'italic')

call s:highlight('markdownH1', s:colors.magenta, s:colors.none, 'bold')
call s:highlight('markdownH2', s:colors.magenta, s:colors.none, 'bold')
call s:highlight('markdownH3', s:colors.magenta, s:colors.none, 'bold')
call s:highlight('markdownH4', s:colors.magenta, s:colors.none, 'bold')
call s:highlight('markdownH5', s:colors.magenta)
call s:highlight('markdownH6', s:colors.magenta)
call s:highlight('markdownHeadingDelimiter', s:colors.gray)

call s:highlight('markdownCode', s:colors.green)
call s:highlight('markdownCodeBlock', s:colors.green)
call s:highlight('markdownCodeDelimiter', s:colors.gray)

call s:highlight('markdownBlockquote', s:colors.white, s:colors.none, 'bold')
call s:highlight('markdownListMarker', s:colors.white, s:colors.none, 'bold')
call s:highlight('markdownOrderedListMarker', s:colors.white, s:colors.none, 'bold')
call s:highlight('markdownRule', s:colors.white, s:colors.none, 'bold')
call s:highlight('markdownHeadingRule', s:colors.white, s:colors.none, 'bold')

call s:highlight('markdownUrlDelimiter', s:colors.white)
call s:highlight('markdownLinkDelimiter', s:colors.white)
call s:highlight('markdownLinkTextDelimiter', s:colors.white)

call s:highlight('markdownUrl', s:colors.blue)
call s:highlight('markdownUrlTitleDelimiter', s:colors.green)

call s:highlight('markdownLinkText', s:colors.orange, s:colors.none, 'italic')
call s:highlight('markdownIdDeclaration', s:colors.yellow, s:colors.none, 'italic')

" define better colors for rust
" --------------------------------------
call s:highlight('rustSelf', s:colors.blue)
call s:highlight('rustPanic', s:colors.red)
call s:highlight('rustAssert', s:colors.red)
call s:highlight('rustKeyword', s:colors.blue)
call s:highlight('rustModPath', s:colors.blue)
call s:highlight('rustTypedef', s:colors.yellow)
call s:highlight('rustModPathSep', s:colors.white)
call s:highlight('rustStructure', s:colors.orange)
call s:highlight('rustEnumVariant', s:colors.orange)

" git-messenger
" --------------------------------------
call s:highlight('gitmessengerHash', s:colors.cyan)
call s:highlight('gitmessengerHeader', s:colors.blue)
call s:highlight('gitmessengerHistory', s:colors.yellow)
call s:highlight('gitmessengerPopupNormal', s:colors.white, s:colors.dark_gray)

" lsp-cxx-highlight
" --------------------------------------
call s:highlight('LspCxxHlSymNamespace', s:colors.blue)
call s:highlight('LspCxxHlSkippedRegionBeginEnd', s:colors.magenta)

call s:highlight('LspCxxHlSymEnum', s:colors.blue)
call s:highlight('LspCxxHlSymEnumMember', s:colors.yellow)
call s:highlight('LspCxxHlSymEnumEnumMember', s:colors.yellow)

call s:highlight('LspCxxHlSymClass', s:colors.blue)
call s:highlight('LspCxxHlSymStruct', s:colors.blue)
call s:highlight('LspCxxHlSymTypeAlias', s:colors.blue)

call s:highlight('LspCxxHlSymField', s:colors.white)
call s:highlight('LspCxxHlSymVariableStatic', s:colors.white, s:colors.none, 'italic')

call s:highlight('LspCxxHlSymMacro', s:colors.magenta)
call s:highlight('LspCxxHlSymUnknownEnumMember', s:colors.magenta)

" coc
" --------------------------------------
call s:highlight('CocUnderline', s:colors.none, s:colors.none, 'underline')

call s:highlight('CocInfoHighlight', s:colors.none, s:colors.none, 'underline')
call s:highlight('CocHintHighlight', s:colors.none, s:colors.none, 'underline')
call s:highlight('CocErrorHighlight', s:colors.none, s:colors.none, 'underline')
call s:highlight('CocWarningHighlight', s:colors.none, s:colors.none, 'underline')

call s:highlight('CocInfoSign', s:colors.blue, s:colors.none, 'italic')
call s:highlight('CocHintSign', s:colors.cyan, s:colors.none, 'italic')
call s:highlight('CocErrorSign', s:colors.red, s:colors.none, 'italic')
call s:highlight('CocWarningSign', s:colors.orange, s:colors.none, 'italic')

call s:highlight('CocInfoFloat', s:colors.blue, s:colors.none, 'italic')
call s:highlight('CocHintFloat', s:colors.cyan, s:colors.none, 'italic')
call s:highlight('CocErrorFloat', s:colors.red, s:colors.none, 'italic')
call s:highlight('CocWarningFloat', s:colors.orange, s:colors.none, 'italic')

call s:highlight('CocHighlightText', s:colors.white, s:colors.dark_gray)
call s:highlight('CocHighlightRead', s:colors.green, s:colors.dark_gray)
call s:highlight('CocHighlightWrite', s:colors.magenta, s:colors.dark_gray)

call s:highlight('CocSelectedText', s:colors.red)

call s:highlight('CocFloating', s:colors.white, s:colors.dark_gray)
call s:highlight('CocCodeLens', s:colors.gray)

call s:highlight('CocListMode', s:colors.white)
call s:highlight('CocListPath', s:colors.gray)

" internal neovim terminal colors
" --------------------------------------
let g:terminal_color_0 = s:colors.dark_gray[0]
let g:terminal_color_1 = s:colors.red[0]
let g:terminal_color_2 = s:colors.green[0]
let g:terminal_color_3 = s:colors.orange[0]
let g:terminal_color_4 = s:colors.blue[0]
let g:terminal_color_5 = s:colors.magenta[0]
let g:terminal_color_6 = s:colors.cyan[0]
let g:terminal_color_7 = s:colors.bwhite[0]
let g:terminal_color_8 = s:colors.gray[0]
let g:terminal_color_9 = s:colors.red[0]
let g:terminal_color_10 = s:colors.green[0]
let g:terminal_color_11 = s:colors.yellow[0]
let g:terminal_color_12 = s:colors.blue[0]
let g:terminal_color_13 = s:colors.magenta[0]
let g:terminal_color_14 = s:colors.cyan[0]
let g:terminal_color_15 = s:colors.white[0]

" cleanup
" --------------------------------------
delfunction s:highlight
unlet s:colors
