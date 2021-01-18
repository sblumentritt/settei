-- @module core.utils
local utils = {}

function utils.keymap(mode, key, value, opts)
    local options = {noremap = true, silent = true}

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.fn.nvim_set_keymap(mode, key, value, options)
end

function utils.create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.cmd('augroup '..group_name)
        vim.cmd('autocmd!')

        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
            vim.cmd(command)
        end

        vim.cmd('augroup END')
    end
end

return utils
