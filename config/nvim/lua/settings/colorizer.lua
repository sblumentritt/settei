-- @module settings.colorizer
local colorizer = {}

function colorizer.toggle_color_highlight()
    if vim.b.enable_color_highlight == nil then
        vim.b.enable_color_highlight = 1
    else
        vim.b.enable_color_highlight = 1 - vim.b.enable_color_highlight
    end

    if vim.b.enable_color_highlight == 1 then
        require("colorizer").attach_to_buffer(0)
        print("nvim-colorizer: highlighting [enabled]")
    else
        require("colorizer").detach_from_buffer(0)
        print("nvim-colorizer: highlighting [disabled]")
    end
end

function colorizer.setup()
    -- return directly when the required module cannot be loaded
    if not pcall(require, "colorizer") then
        return
    end

    -- key mappings
    -- --------------------------------------
    local utils = require("core.utils")

    -- toggle color highlighting in current buffer
    utils.keymap(
        "n",
        "<leader>tc",
        "<cmd>lua require('settings.colorizer').toggle_color_highlight()<cr>"
    )

    -- configurations
    -- --------------------------------------
    require("colorizer").setup({"!*";}, {RRGGBBAA = true; css = true;})
end

return colorizer
