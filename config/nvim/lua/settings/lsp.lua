-- @module settings.lsp
local lsp = {}

function lsp.mappings()
    local utils = require('core.utils')

    -- trigger completion
    utils.keymap('i', '<C-space>', '<cmd>lua require("completion").triggerCompletion()<CR>')

    -- <TAB> completion mapping + helper function
    utils.keymap('i', '<TAB>', '<cmd>lua require("completion").smart_tab()<CR>')

    -- show type info and short doc for identifier under cursor
    utils.keymap('n', '<leader>sd', '<cmd>lua vim.lsp.buf.hover()<CR>')

    -- goto definition under cursor
    utils.keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')

    -- goto type definition under cursor
    utils.keymap('n', 'gtd', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

    -- goto reference of identifier under cursor
    -- opens a list if multiple are available
    utils.keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

    -- rename object under cursor for the whole project
    utils.keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

    -- list of current document symbols
    utils.keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

    -- search interactive in workspace symbols
    utils.keymap('n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

    -- show available code actions for current cursor position
    utils.keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')

    -- show diagnostics in a floating windows for the current line
    utils.keymap('n', '<leader>sld', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')

    -- toggle format on save
    utils.keymap('n', '<F12>', '<cmd>lua require("settings.lsp").toggle_format_on_save()<CR>')
end

function lsp.toggle_format_on_save()
    if vim.g.format_on_save_toggle == nil then
        vim.g.format_on_save_toggle = 1
    else
        vim.g.format_on_save_toggle = 1 - vim.g.format_on_save_toggle
    end

    if vim.g.format_on_save_toggle == 1 then
        print('format on save: [enabled]')
        -- TODO: find better way to do this in lua
        vim.api.nvim_exec(
        [[
        augroup lsp_format_on_save
            autocmd!
            " currently only C and C++ files are supported
            autocmd BufWritePre *.{c,cpp,h,hpp} lua vim.lsp.buf.formatting_sync(nil, 1000)
        augroup END
        ]]
        , false)
    else
        print('format on save: [disabled]')
        -- TODO: find better way to do this in lua
        vim.api.nvim_exec(
        [[
        autocmd! lsp_format_on_save
        ]]
        , false)
    end
end

function lsp.autocommands()
    -- use completion-nvim in every buffer
    vim.cmd [[autocmd BufEnter * lua require('completion').on_attach()]]
    -- switch between header and source files
    vim.cmd [[autocmd FileType c,cpp nnoremap <buffer><silent> <F4> :ClangdSwitchSourceHeader<CR>]]
end

function lsp.configurations()
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

    -- lspconfig
    local lspconfig = require('lspconfig')
    local lsp_status = require('lsp-status')

    local function common_attach(client)
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
                    globals = {'vim', 'use'},
                    disable = {'lowercase-global'}
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
end

function lsp.setup()
    -- return directly when the required module cannot be loaded
    if not pcall(require, 'lspconfig') then
        return
    end

    -- enable format on save when starting neovim
    -- TODO: replace this with a direct lua call
    vim.cmd('silent lua require("settings.lsp").toggle_format_on_save()')

    lsp.mappings()
    lsp.autocommands()
    lsp.configurations()
end

return lsp
