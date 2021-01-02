-- @module core.utils
local utils = {}

function utils.keymap(type, key, value)
    vim.fn.nvim_set_keymap(type, key, value, {noremap = true, silent = true});
end

return utils
