-- @module core.rules
local rules = {}

local awful = require("awful")
local beautiful = require("beautiful")
local bindings = require("core.bindings")

function rules.setup()
    -- Rules to apply to new clients (through the "manage" signal).
    awful.rules.rules = {
        -- All clients will match this rule.
        {
            rule = {},
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                size_hints_honor = false,
                keys = bindings.client_keys(),
                buttons = bindings.client_mouse_buttons(),
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            },
        },

        -- custom launcher
        {
            rule = { instance = "launcher" },
            properties = {
                floating = true,
                placement = awful.placement.centered,
            },
        },

        -- Floating clients.
        {
            rule_any = {
                instance = {
                    "pinentry",
                },
                class = {
                    "Wpa_gui",
                    "Nitrogen",
                },
                role = {
                    "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
                }
            },
            properties = {
                floating = true,
                placement = awful.placement.centered + awful.placement.no_offscreen,
            },
        },

        {
            rule_any = {
                floating = true,
            },
            properties = {
                placement = awful.placement.centered + awful.placement.no_offscreen,
            },
        },

        -- fix JetBrains dialog problems
        {
            rule = {
                class = "jetbrains-.*",
            },
            properties = {
                focus = true,
                buttons = bindings.client_mouse_buttons_jetbrains(),
            },
        },
        {
            rule = {
                class = "jetbrains-.*",
                name = "win.*",
            },
            properties = {
                titlebars_enabled = false,
                focusable = false,
                focus = true,
                floating = true,
                placement = awful.placement.restore,
            },
        },

        -- Remove titlebars from normal clients
        {
            rule_any = {
                type = {"normal"},
            },
            properties = {
                titlebars_enabled = false,
            },
        },
        -- Add titlebars to dialogs clients
        {
            rule_any = {
                type = {"dialog"},
            },
            properties = {
                titlebars_enabled = true,
            },
        },
    }
end

return rules
