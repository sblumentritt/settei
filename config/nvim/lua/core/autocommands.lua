-- @module core.autocommands
local autocommands = {}

function autocommands.setup()
    local autocmd_definitions = {
        -- update filetypes
        update_filetypes = {
            {"BufRead,BufNewFile", "*.{c,h}", "set filetype=c"},
            {"BufRead,BufNewFile", ".{clang-}*", "set filetype=yaml"},

            {"BufRead,BufNewFile", "config", "set filetype=config"},
            {"BufRead,BufNewFile", "*.{conf,config}", "set filetype=config"},

            {"BufRead,BufNewFile", "*.iwyu", "set filetype=iwyu"},

            {
                "Filetype", "yaml,xml,html,css,scss,less,javascript",
                "set tabstop=2 shiftwidth=2 softtabstop=2"
            },

            {
                "Filetype", "markdown",
                "set tabstop=2 shiftwidth=2 softtabstop=2 textwidth=80 colorcolumn=80"
            },
        },

        -- highlight keywords in the current window
        highlight_keywords = {
            {
                "Syntax", "*",
                [[call matchadd('GenericBold', '\W\zs\(TODO\|FIXME\|FIX\|BUG\|HACK\|ERROR\)')]]
            },
            {
                "Syntax", "*",
                [[call matchadd('GenericBold', '\W\zs\(NOTE\|INFO\|NOTICE\|DEBUG\)')]]
            },
        },

        -- remove trailing whitespace
        remove_trailing_whitespaces = {
            {"BufWritePre", "*", [[%s/\s\+$//e]]},
        },

        -- disable number column in terminal buffer
        disable_term_num_col = {
            {"TermOpen", "*", "setlocal nonumber norelativenumber"},
        },

        auto_close_windows = {
            -- close preview window if autocompletion popup is gone
            {"InsertLeave,CompleteDone", "*", "if pumvisible() == 0 | pclose | endif"},
            -- close quickfix and plugin windows automatically if main window is closed
            {
                "WinEnter", "*",
                "if winnr('$') == 1 && getbufvar(winbufnr(winnr()), '&buftype') == 'quickfix' | q | endif"
            },
        },

        -- trigger autoread whenever switching buffer or focusing neovim again
        autoread_trigger = {
            {"FocusGained,BufEnter", "*", ":silent! !"},
        },

        -- slowest but most accurate method which should fix broken syntax highlighting
        highlight_from_file_start = {
            {"BufEnter", "*", ":syntax sync fromstart"},
        },
    }

    require("core.utils").create_augroups(autocmd_definitions)

    -- TODO: find better way to define the following augroups in lua

    -- return to last edit position when opening files
    vim.api.nvim_exec(
    [[
    augroup last_position
        autocmd!
        autocmd BufReadPost * call Jump_last_position()

        function Jump_last_position()
            execute 'filetype detect'
            if &filetype =~# 'commit'
                return
            else
                if line("'\"") > 1 && line("'\"") <= line('$')
                    execute 'normal! g`"'
                endif
            endif
        endfunction
    augroup END
    ]]
    , false)

    -- automatically create a directory if it is not available on save of a file
    vim.api.nvim_exec(
    [[
    augroup auto_mkdir
        autocmd!
        autocmd BufWritePre * call Auto_mkdir_if_needed(expand('<afile>'), +expand('<abuf>'))

        function Auto_mkdir_if_needed(file, buf)
            if empty(getbufvar(a:buf, '&buftype')) && a:file !~# "\v^\w+\:\/"
                let dir = fnamemodify(a:file, ':h')
                if !isdirectory(dir)
                    call mkdir(dir, 'p')
                endif
            endif
        endfunction
    augroup END
    ]]
    , false)
end

return autocommands
