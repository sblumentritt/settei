-- @module core.mappings
local mappings = {}

function mappings.setup()
    local utils = require("core.utils")

    -- disable unused key mappings
    utils.keymap("", "K", "<nop>")
    utils.keymap("", "q:", "<nop>")
    utils.keymap("n", "<F1>", "<nop>")
    utils.keymap("i", "<F1>", "<nop>")
    utils.keymap("n", "Q", "<nop>")
    utils.keymap("n", "<space>", "<nop>")
    utils.keymap("v", "<space>", "<nop>")

    -- disable arrow keys in normal mode
    utils.keymap("n", "<up>", "<nop>")
    utils.keymap("n", "<left>", "<nop>")
    utils.keymap("n", "<down>", "<nop>")
    utils.keymap("n", "<right>", "<nop>")

    -- faster saving
    utils.keymap("n", "<leader>w", "<cmd>w<cr>")
    utils.keymap("v", "<leader>w", "<cmd>w<cr>")

    -- prevent clipboard overwrite on 'put' with the help of the black hole buffer
    utils.keymap("v", "p", '"_dP')

    -- disable highlighted search
    utils.keymap("n", "<F8>", "<cmd>nohl<cr>")

    -- substitute all occurrences of word under cursor
    -- TODO: find better way to do this in lua
    vim.api.nvim_exec([[nnoremap <leader>sw :%s/\<<C-r><C-w>\>//g<left><left>]], false)

    -- substitute all occurrences of the current selection
    -- NOTE: copies selection to clipboard
    -- TODO: find better way to do this in lua
    vim.api.nvim_exec([[vnoremap <leader>sw y:%s/<c-r>"//g<left><left>]], false)

    -- stay at search position
    utils.keymap("n", "*", [[m`<cmd>keepjumps normal! *``<cr>]])
    utils.keymap("n", "#", [[m`<cmd>keepjumps normal! #``<cr>]])

    -- improve movement
    utils.keymap("n", "<", "0")
    utils.keymap("n", ">", "$")
    utils.keymap("n", "<C-left>", "b")
    utils.keymap("n", "<C-right>", "w")

    -- move lines up/down
    utils.keymap("n", "<C-j>", "<cmd>m .+<cr>==")
    utils.keymap("n", "<C-k>", "<cmd>m .-2<cr>==")
    utils.keymap("v", "<C-j>", "<cmd>m '>+1<cr>gv=gv")
    utils.keymap("v", "<C-k>", "<cmd>m '<-2<cr>gv=gv")

    utils.keymap("n", "<C-down>", "<cmd>m .+<cr>==")
    utils.keymap("n", "<C-up>", "<cmd>m .-2<cr>==")
    utils.keymap("v", "<C-down>", "<cmd>m '>+1<cr>gv=gv")
    utils.keymap("v", "<C-up>", "<cmd>m '<-2<cr>gv=gv")

    -- keep selection after indentation
    utils.keymap("v", "<", "<gv")
    utils.keymap("v", ">", ">gv")

    -- movement between splits
    utils.keymap("n", "<A-j>", "<C-w><C-j>")
    utils.keymap("n", "<A-k>", "<C-w><C-k>")
    utils.keymap("n", "<A-l>", "<C-w><C-l>")
    utils.keymap("n", "<A-h>", "<C-w><C-h>")

    -- close split
    utils.keymap("n", "cs", "<cmd>close<cr>")

    -- close terminal buffer
    vim.cmd([[autocmd TermOpen * nmap <buffer> <ESC> :bdelete!<cr>]])

    -- toggle/open all folds
    utils.keymap("n", "<F9>", "za")
    utils.keymap("n", "<leader><F9>", "zR")

    -- use <CR> to confirm completion (<C-g>u means break undo chain at current position)
    -- TODO: find better way to do this in lua
    vim.api.nvim_exec(
    [[
    if exists('*complete_info')
        inoremap <expr> <cr> complete_info()['selected'] != '-1' ? '<C-y>' : '<C-g>u<cr>'
    else
        inoremap <expr> <cr> pumvisible() ? '<C-y>' : '<C-g>u<cr>'
    endif
    ]]
    , false)
end

return mappings
