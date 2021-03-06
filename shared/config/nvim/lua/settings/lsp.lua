-- @module settings.lsp
local lsp = {}

local function load_mappings()
    local utils = require("core.utils")

    -- show type info and short doc for identifier under the cursor
    utils.keymap("n", "<leader>sd", "<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>")

    -- goto definition under cursor
    utils.keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")

    -- show definitions and references of identifier under the cursor
    utils.keymap("n", "<leader>si", "<cmd>lua require('lspsaga.provider').lsp_finder()<cr>")

    -- rename object under the cursor for the whole project
    utils.keymap("n", "<leader>rn", "<cmd>lua require('lspsaga.rename').rename()<cr>")

    -- list of current document symbols
    utils.keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.document_symbol()<cr>")

    -- search interactive in workspace symbols
    utils.keymap("n", "<leader>lw", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>")

    -- show available code actions for current cursor position
    utils.keymap("n", "<leader>ca", "<cmd>lua require('lspsaga.codeaction').code_action()<cr>")
    -- show available code actions for current selections
    utils.keymap(
        "v",
        "<leader>ca",
        "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<cr>"
    )

    -- show diagnostics in a floating windows for the current line
    utils.keymap(
        "n",
        "<leader>sld",
        "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<cr>"
    )

    -- toggle format on save
    utils.keymap("n", "<F12>", "<cmd>lua require('settings.lsp').toggle_format_on_save()<cr>")
end

local function load_autocommands()
    local autocmd_definitions = {
        lsp_related = {
            -- switch between header and source files
            {"FileType", "c,cpp", "nnoremap <buffer><silent> <F4> :ClangdSwitchSourceHeader<cr>"},
            -- show notification for code action in normal mode for the current line
            {"CursorHold", "*", "lua require('nvim-lightbulb').update_lightbulb()"},
            -- call signature help on in insert mode
            -- NOTE: restricted to C++ and C as the function prints a message when no
            --       signature help can be found. This can be really annoying.
            {
                "CursorMovedI", "*.cpp,*.hpp,*.c,*.h",
                "lua require('lspsaga.signaturehelp').signature_help()"
            },
        }
    }

    require("core.utils").create_augroups(autocmd_definitions)
end

local function load_configurations()
    -- diagnostic (built-in)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = {
                prefix = ">",
                spacing = 1,
            },
            signs = true,
            update_in_insert = true,
        }
    )

    -- update diagnostic sign text
    vim.fn.sign_define("LspDiagnosticsSignError", {
        text = "●",
        texthl = "LspDiagnosticsSignError"
    })

    vim.fn.sign_define("LspDiagnosticsSignWarning", {
        text = "●", texthl = "LspDiagnosticsSignWarning"
    })

    vim.fn.sign_define("LspDiagnosticsSignInformation", {
        text = "●", texthl = "LspDiagnosticsSignInformation"
    })

    vim.fn.sign_define("LspDiagnosticsSignHint", {
        text = "●", texthl = "LspDiagnosticsSignHint"
    })

    -- lspconfig
    local lspconfig = require("lspconfig")
    local lsp_status = require("lsp-status")

    -- clangd
    lspconfig.clangd.setup({
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy=true",
            "--completion-style=bundled",
            "--function-arg-placeholders=false",
            "--header-insertion=iwyu",
            "--header-insertion-decorators",
            "--pch-storage=memory",
            "--suggest-missing-includes",

            "--log=error"
        },

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
            "lua-language-server",
        },
        settings = {
            Lua = {
                completion = {
                    keywordSnippet = "Disable",
                },
                diagnostics = {
                    globals = {"vim", "use"},
                    disable = {"lowercase-global"}
                },
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ";"),
                },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                },
                telemetry = {
                    enable = false
                },
            },
        },
    })

    -- lspsaga
    require("lspsaga").init_lsp_saga({
        use_saga_diagnostic_sign = false,
        code_action_icon = "",
        finder_definition_icon = "",
        finder_reference_icon = "",
        definition_preview_icon = "",
        dianostic_header_icon = "",
        rename_prompt_prefix = '>',

        finder_action_keys = {
            open = "<cr>",
            quit = "<ESC>",
        }
    })

    -- nvim-lightbulb
    vim.fn.sign_define("LightBulbSign", {
        text = "", numhl = "LightBulbSign"
    })
end

function lsp.setup()
    -- return directly when the required module cannot be loaded
    if not pcall(require, "lspconfig")
        or not pcall(require, "lspsaga")
        or not pcall(require, "nvim-lightbulb") then
        return
    end

    -- enable format on save when starting neovim
    -- TODO: replace this with a direct lua call
    vim.cmd("silent lua require('settings.lsp').toggle_format_on_save()")

    load_mappings()
    load_autocommands()
    load_configurations()

end

function lsp.toggle_format_on_save()
    if vim.g.format_on_save_toggle == nil then
        vim.g.format_on_save_toggle = 1
    else
        vim.g.format_on_save_toggle = 1 - vim.g.format_on_save_toggle
    end

    if vim.g.format_on_save_toggle == 1 then
        print("format on save: [enabled]")
        local autocmd_definitions = {
            lsp_format_on_save = {
                -- currently only C and C++ files are supported
                {"BufWritePre", "*.{c,cpp,h,hpp}", "lua vim.lsp.buf.formatting_sync(nil, 1000)"}
            }
        }
        require("core.utils").create_augroups(autocmd_definitions)
    else
        print("format on save: [disabled]")
        vim.cmd("autocmd! lsp_format_on_save")
    end
end

return lsp
