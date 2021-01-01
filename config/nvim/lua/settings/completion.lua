-- @module settings.completion
local completion = {}

function completion.setup()
    -- return directly when the required module cannot be loaded
    if not pcall(require, 'completion') then
        return
    end

    -- configurations
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

    -- register custom sources from other plugins
    local completion_nvim = require('completion')

    completion_nvim.addCompletionSource('cmake', require('cmake').complete_item)
    completion_nvim.addCompletionSource('bitbake', require('bitbake').complete_item)

    -- filetype specific chain list
    vim.g.completion_chain_complete_list = {
        c = {
            {complete_items = {'lsp'}},
        },

        cpp = {
            {complete_items = {'lsp'}},
        },

        lua = {
            {complete_items = {'lsp'}},
        },

        cmake = {
            {complete_items = {'cmake'}},
            {complete_items = {'buffers', 'path'}},
        },

        bitbake = {
            {complete_items = {'bitbake'}},
            {complete_items = {'buffers', 'path'}},
        },

        default = {
            {complete_items = {'lsp', 'path', 'buffers'}},
        },
    }
end

return completion
