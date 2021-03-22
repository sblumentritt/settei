-- @module settings.compe
local compe = {}

local function load_mappings()
    local utils = require("core.utils")

    -- trigger completion
    utils.keymap("i", "<C-space>", "compe#complete()", {expr = true})

    -- confirm completion
    utils.keymap("i", "<cr>", "compe#confirm('<cr>')", {expr = true})

    -- <TAB> completion mapping + helper function
    utils.keymap("i", "<TAB>", "<cmd>lua require('settings.compe').smart_tab()<cr>")
end

function compe.setup()
    -- return directly when the required module cannot be loaded
    if not pcall(require, "compe") then
        return
    end

    require("compe").setup({
        enabled = true,
        autocomplete = true,
        documentation = false,
        max_abbr_width = 55,
        source = {
            path = true,
            buffer = true,
            nvim_lsp = true,
            cmake = true,
        },
    })

    -- cmake source
    vim.g["cmake#supported_languages"] = {"C", "CXX"}
    vim.g["cmake#blacklist"] = {
        "XCODE", "OBJC", "OBJCXX", "OSX",
        "ANDROID", "VS", "Fortran", "Swift",
        "Eclipse", "ECLIPSE",
    }

    load_mappings()
end

function compe.smart_tab()
    if vim.fn.pumvisible() ~= 0 then
        vim.api.nvim_eval([[feedkeys("\<c-n>", "n")]])
        return
    end

    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        vim.api.nvim_eval([[feedkeys("\<tab>", "n")]])
        return
    end

    vim.fn["compe#complete"]();
end

return compe
