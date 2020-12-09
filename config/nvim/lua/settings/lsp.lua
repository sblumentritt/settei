-- key mappings
-- --------------------------------------
local map = function(type, key, value)
    vim.fn.nvim_set_keymap(type, key, value, {noremap = true, silent = true});
end

-- trigger completion
map('i', '<C-space>', '<cmd>lua require("completion").triggerCompletion()<CR>')

-- <TAB> completion mapping + helper function
map('i', '<TAB>', '<cmd>lua require("completion").smart_tab()<CR>')

-- show type info and short doc for identifier under cursor
map('n', '<leader>sd', '<cmd>lua vim.lsp.buf.hover()<CR>')

-- goto definition under cursor
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')

-- goto type definition under cursor
map('n', 'gtd', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

-- goto reference of identifier under cursor
-- opens a list if multiple are available
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

-- rename object under cursor for the whole project
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

-- list of current document symbols
map('n', '<leader>ld', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-- search interactive in workspace symbols
map('n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

-- show available code actions for current cursor position
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')

-- show diagnostics in a floating windows for the current line
map('n', '<leader>sld', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')

-- autocommands
-- --------------------------------------
-- use completion-nvim in every buffer
vim.cmd [[autocmd BufEnter * lua require('completion').on_attach()]]
-- switch between header and source files
vim.cmd [[autocmd FileType c,cpp nnoremap <buffer><silent> <F4> :ClangdSwitchSourceHeader<CR>]]

-- configurations
-- --------------------------------------
-- diagnostic (built-in)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {
            prefix = '>',
            spacing = 1,
        },
        signs = true,
        update_in_insert = true,
    }
)

-- update diagnostic sign text
vim.fn.sign_define('LspDiagnosticsSignError', {
    text = '●',
    texthl = 'LspDiagnosticsSignError'
})

vim.fn.sign_define('LspDiagnosticsSignWarning', {
    text = '●', texthl = 'LspDiagnosticsSignWarning'
})

vim.fn.sign_define('LspDiagnosticsSignInformation', {
    text = '●', texthl = 'LspDiagnosticsSignInformation'
})

vim.fn.sign_define('LspDiagnosticsSignHint', {
    text = '●', texthl = 'LspDiagnosticsSignHint'
})

-- completion-nvim
vim.g.completion_timer_cycle = 200
vim.g.completion_enable_auto_hover = 0
vim.g.completion_trigger_on_delete = 1
vim.g.completion_auto_change_source = 1
vim.g.completion_word_separator = '[^a-zA-Z0-9_]'

vim.g.completion_abbr_length = 55 -- completion item (left)
vim.g.completion_menu_length = 30 -- extra info for completion item (right)

vim.g.completion_items_priority = {
    Method = 10,
    Function = 7,
    Variables = 7,
    Field = 5,
    Interfaces = 5,
    Constant = 5,
    Class = 5,
    Keyword = 4,
    Buffers = 1,
    File = 0
}

-- lspconfig
local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')

local common_attach = function(client)
    require('completion').on_attach(client)
end

-- clangd
lspconfig.clangd.setup({
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy=true',
        '--completion-style=bundled',
        '--function-arg-placeholders=false',
        '--header-insertion=iwyu',
        '--header-insertion-decorators',
        '--pch-storage=memory',
        '--suggest-missing-includes',

        '--log=error'
    },
    on_attach = common_attach,

    init_options = {
        -- required for lsp-status
        clangdFileStatus = true,
    },

    handlers = lsp_status.extensions.clangd.setup(),
    capabilities = lsp_status.capabilities,
})

-- lua-language-server
lspconfig.sumneko_lua.setup({
    cmd = {
        '/usr/lib/lua-language-server/lua-language-server',
        '-E',
        '/usr/share/lua-language-server/main.lua'
    },
    settings = {
        Lua = {
            completion = {
                keywordSnippet = "Disable",
            },
            diagnostics = {
                globals = {'vim'}
            },
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';'),
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
    },

    on_attach = common_attach,
})
