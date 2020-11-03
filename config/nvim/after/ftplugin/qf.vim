" update options
" --------------------------------------
setlocal errorformat=%f\|%l\ col\ %c\|%m

" cleanup
" --------------------------------------
"  reset options on filetype change
let b:undo_ftplugin = 'setlocal errorformat<'
