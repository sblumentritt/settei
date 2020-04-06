" --------------------------------------
" key mappings
" --------------------------------------
" avoid executing the plugin twice
if exists('g:loaded_mappings')
    finish
endif
let g:loaded_mappings = 1

" disable unused key mappings
map K <nop>
map q: <nop>
imap <F1> <nop>
nmap <F1> <nop>
nnoremap Q <nop>
noremap <F1> <nop>
nmap <space> <nop>
vmap <space> <nop>

" disable arrow keys in normal mode
nnoremap <up> <nop>
nnoremap <left> <nop>
nnoremap <down> <nop>
nnoremap <right> <nop>

" disable arrow keys in visual mode
vnoremap <up> <nop>
vnoremap <left> <nop>
vnoremap <down> <nop>
vnoremap <right> <nop>

" faster saving
nnoremap <leader>w :w<CR>
vnoremap <leader>w :w<CR>

" disable highlighted search
noremap <silent> <F8> :nohl<CR>

" substitute all occurrences of word under cursor
nnoremap <leader>sw :%s/\<<C-r><C-w>\>//g<left><left>
" substitute all occurrences of the current selection
" NOTE: copies selection to clipboard
vnoremap <leader>sw y:%s/<C-r>"//g<left><left>

" stay at search position
nnoremap * m`:keepjumps normal! *``<cr>
nnoremap # m`:keepjumps normal! #``<cr>

" improve movement
nnoremap < 0
nnoremap > $
nnoremap <C-Left> b
nnoremap <C-Right> w

" move lines up/down
nnoremap <silent> <C-j> :m .+<CR>==
nnoremap <silent> <C-k> :m .-2<CR>==
vnoremap <silent> <C-j> :m '>+1<CR>gv=gv
vnoremap <silent> <C-k> :m '<-2<CR>gv=gv

nnoremap <silent> <C-Down> :m .+<CR>==
nnoremap <silent> <C-Up> :m .-2<CR>==
vnoremap <silent> <C-Down> :m '>+1<CR>gv=gv
vnoremap <silent> <C-Up> :m '<-2<CR>gv=gv

" keep selection after indentation
vnoremap < <gv
vnoremap > >gv

" movement between splits
nnoremap <A-j> <C-w><C-j>
nnoremap <A-k> <C-w><C-k>
nnoremap <A-l> <C-w><C-l>
nnoremap <A-h> <C-w><C-h>

" close split
nnoremap <silent> cs :close<CR>

" close terminal buffer
autocmd TermOpen * nmap <buffer> <ESC> :bdelete!<CR>
