-- @module settings.mixed
local mixed = {}

function mixed.setup()
    local utils = require("core.utils")

    -- gitgutter configurations
    -- --------------------------------------
    vim.g.gitgutter_sign_added = "+"
    vim.g.gitgutter_sign_removed = "-"
    vim.g.gitgutter_sign_modified = "~"
    vim.g.gitgutter_sign_modified_removed = "~_"
    vim.g.gitgutter_sign_removed_first_line = "‾"

    if vim.fn.executable("rg") == 1 then
        vim.g.gitgutter_grep = "rg --color never --no-line-number"
    end

    -- vim-bbye configurations
    -- --------------------------------------
    utils.keymap("n", "gb", "<cmd>Bdelete<cr>")

    -- vim-markdown configurations
    -- --------------------------------------
    vim.g.markdown_syntax_conceal = 0
    vim.g.markdown_fenced_languages = {
        "cmake", "c", "cpp", "vim", "sh", "rust",
        "viml=vim", "bash=sh"
    }

    -- ft-sh-syntax configurations
    -- --------------------------------------
    vim.g.sh_fold_enabled = 5

    -- fzf configurations
    -- --------------------------------------
    vim.g.fzf_buffers_jump = 1
    vim.g.fzf_preview_window = ""
    vim.g.fzf_layout = {down = "~25%"}

    -- override default Rg implementation to include hidden files
    -- TODO: find better way to do this in lua
    vim.api.nvim_exec(
    [[
    command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=always' . ' --smart-case --hidden --glob "!.git" --glob "!dependency/**" ' . shellescape(<q-args>), 1, <bang>0)
    ]]
    , false)

    -- hide statusline in fzf buffer
    -- TODO: find better way to do this in lua
    vim.api.nvim_exec(
    [[
    augroup hide_fzf_statusline
        autocmd! FileType fzf
        autocmd FileType fzf set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 ruler
    augroup END
    ]]
    , false)

    -- custom keybindings for fzf
    utils.keymap("n", "<F2>", "<cmd>Files<cr>")
    utils.keymap("n", "<leader>fr", "<cmd>Rg<cr>")
    utils.keymap("n", "<leader><F2>", "<cmd>Buffers<cr>")

    -- undotree configurations
    -- --------------------------------------
    vim.g.undotree_HelpLine = 0
    vim.g.undotree_SplitWidth = 35
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_DiffpanelHeight = 15
    vim.g.undotree_SetFocusWhenToggle = 1
end

return mixed
