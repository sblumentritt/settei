-- key mappings
-- --------------------------------------
local map = function(type, key, value)
    vim.fn.nvim_set_keymap(type, key, value, {noremap = true, silent = true});
end

-- toggle color highlighting in current buffer
map('n', '<leader>tc', '<cmd>lua toggle_color_highlight()<CR>')

-- TODO: do not pollute the global namespace, maybe use the returned table approach
function toggle_color_highlight()
    if vim.b.enable_color_highlight == nil then
        vim.b.enable_color_highlight = 1
    else
        vim.b.enable_color_highlight = 1 - vim.b.enable_color_highlight
    end

    if vim.b.enable_color_highlight == 1 then
        require('colorizer').attach_to_buffer(0)
        print('nvim-colorizer: highlighting [enabled]')
    else
        require('colorizer').detach_from_buffer(0)
        print('nvim-colorizer: highlighting [disabled]')
    end
end

-- configurations
-- --------------------------------------
require('colorizer').setup({'!*';}, {RRGGBBAA = true; css = true;})
