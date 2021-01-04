-- @module core.utils
local utils = {}

function utils.keymap(type, key, value)
    vim.fn.nvim_set_keymap(type, key, value, {noremap = true, silent = true});
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
