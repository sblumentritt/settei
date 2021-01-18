-- @module core.options
local options = {}

function options.setup()
    -- create directory which should hold undo files
    local neovim_undo_dir = vim.fn.stdpath("data") .. "/site/undo"
    if not vim.fn.isdirectory(neovim_undo_dir) then
        vim.fn.mkdir(neovim_undo_dir)
    end

    -- enable filetype detection
    vim.cmd("filetype plugin indent on")
    -- enable syntax highlighting
    vim.cmd("syntax on")

    -- load color scheme
    vim.cmd("colorscheme susumu")

    local nvim_options = {
        fileencoding = "utf-8",
        fileencodings = "utf-8",

        matchpairs = vim.o.matchpairs .. ",<:>",
        backspace = "indent,eol,start",

        -- don't wrap text if it is longer than the width of the window
        wrap = false,
        -- on bracket insert briefly jump to the matching one
        showmatch = true,
        -- set maximum width of a text
        textwidth = 100,
        -- define the minimal width of a window
        winminwidth = 20,

        -- always show relative line numbers
        number = true,
        relativenumber = true,

        -- open splits below and to the right by default
        splitbelow = true,
        splitright = true,

        hlsearch = true,
        incsearch = true,
        smartcase = true,
        ignorecase = true,
        -- show effect of a command incrementally e.g. substitute
        inccommand = "nosplit",

        smarttab = true,
        expandtab = true,

        autoindent = true,
        smartindent = false, -- disabled because deprecated and should not be used

        -- prevent special treatment of lines starting with '#'
        cinkeys = "0{,0},0),0],:,!^F,o,O,e",
        indentkeys = "0{,0},0),0],:,!^F,o,O,e",

        tabstop = 4,
        shiftwidth = 4,
        softtabstop = 4,

        -- raise dialog for e.g. unsaved changes in a buffer on quiet
        confirm = true,
        -- disable backup files and bells
        backup = false,
        swapfile = false,
        errorbells = false,
        visualbell = false,
        writebackup = false,

        -- show line and column number of cursor position
        ruler = true,
        -- don't unload buffer when it is abandoned
        hidden = true,
        -- disable folds and always have them open
        foldenable = false,

        -- enable command-line completion suggestion
        wildmenu = true,
        -- get old wildmenu style instead of new default popup menu style
        wildoptions = "",

        -- enable mouse support for all modes
        mouse = "a",
        -- always use the clipboard for all operations
        clipboard = "unnamedplus",
        -- settings for diff mode
        diffopt = "vertical,filler,internal,algorithm:patience",

        -- show popup menu also for only one match
        -- don't insert any text without user selection
        -- don't auto select a match in the menu
        completeopt = "menu,menuone,noinsert,noselect",

        -- disable mode messages on last line
        showmode = false,
        -- don't give ins-completion-menu messages e.g. 'match 1 of 2'
        shortmess = vim.o.shortmess .. "c",
        -- always show status line for last window
        laststatus = 2,
        -- always draw signcolumn
        signcolumn = "yes",

        -- if file changes outside of neovim read it again
        autoread = true,
        -- time in milliseconds used for CursorHold autocommand
        updatetime = 100,

        -- disabling lazyredraw removes flickering cursor
        lazyredraw = false,

        -- enable if terminal supports 24-bit colors
        termguicolors = true,

        -- change cursor shape if terminal supports it
        guicursor = "n-c-r-cr:hor20,i-ci-ve:ver25,v:block",

        -- enable persistent undo
        undodir = neovim_undo_dir,
        undofile = true,

        -- improve session save option
        sessionoptions = "blank,buffers,folds,help,localoptions,tabpages,winsize",

        -- use a whitespace as fill character for folds and end-of-buffer indication
        fillchars = "fold: ,eob: ,diff:-",

        -- fold related options
        foldlevel = 99,
        foldmethod = "syntax",
    }

    -- define backend for vimgrep/grep command
    if vim.fn.executable("rg") == 1 then
        nvim_options.grepprg = "rg --vimgrep --no-heading --smart-case --hidden --follow"
        nvim_options.grepformat = "%f:%l:%c:%m"
    else
        nvim_options.grepprg = "grep -n --with-filename -I -R"
        nvim_options.grepformat = "%f:%l:%m"
    end

    -- TODO: write this in lua
    vim.api.nvim_exec(
    [[
    set foldtext=CustomFoldText()

    " improved fold text for languages which use braces '{}'
    function! CustomFoldText()
        let l:line_start = getline(v:foldstart)
        let l:line_end = getline(v:foldend)

        let l:fold_text = l:line_start

        " check if the fold contains braces and handle them differently
        let l:filtered_start_brace = substitute(l:line_start, '^.*{.*$', '{', 'g')
        if l:filtered_start_brace == '{'
            let l:filtered_end_brace = substitute(l:line_end, '^.*}.*$', '}', 'g')
            if l:filtered_end_brace == '}'
                let l:fold_text = l:fold_text . substitute(l:line_end, '^.*}\(.*\)$', '...}\1', 'g')
            endif
        endif

        let l:fold_count = v:foldend - v:foldstart + 1

        return l:fold_text . ' > ' . l:fold_count
    endfunction
    ]]
    , false)

    -- workaround until https://github.com/neovim/neovim/pull/13479 is integrated
    local opts_info = vim.api.nvim_get_all_options_info()

    local set_option = setmetatable({}, {
        __newindex = function(self, key, value)
            vim.o[key] = value
            local scope = opts_info[key].scope
            if scope == 'win' then
                vim.wo[key] = value
            elseif scope == 'buf' then
                vim.bo[key] = value
            end
        end
    })

    for name,value in pairs(nvim_options) do
        set_option[name] = value
    end
end

return options
