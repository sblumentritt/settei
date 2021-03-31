-- @module modules.taskbar
local taskbar = {}

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local function tasklist_mouse_buttons()
    return gears.table.join(
        awful.button({}, 1,
            function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal("request::activate", "tasklist", {raise = true})
                end
            end
        )
    )
end

local function icon_only_tasklist(s)
    return awful.widget.tasklist({
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_mouse_buttons(),
            layout = {
                spacing_widget = {
                    {
                        forced_width = 15,
                        forced_height = 30,
                        thickness = 2,
                        color = '#998f8550',
                        widget = wibox.widget.separator,
                    },
                    valign = 'center',
                    halign = 'center',
                    widget = wibox.container.place,
                },
                spacing = 4,
                layout = wibox.layout.fixed.horizontal,
            },
            widget_template = {
                {
                    id = 'background_role',
                    wibox.widget.base.make_widget(),
                    forced_height = 4,
                    widget = wibox.container.background,
                },
                {
                    {
                        {
                            id = 'clienticon',
                            widget = awful.widget.clienticon,
                        },
                        margins = 7,
                        widget = wibox.container.margin,
                    },
                    valign = 'center',
                    halign = 'center',
                    widget = wibox.container.place,
                },
                nil,
                create_callback = function(self, c, _, _)
                    self:get_children_by_id('clienticon')[1].client = c
                end,
                layout = wibox.layout.align.vertical,
            },
        }
    )
end

local function extend_global_keys()
    local globalkeys = gears.table.join(
        root.keys(),
        awful.key({modkey}, "b",
            function()
                local screen = awful.screen.focused()
                screen.taskbar_widget.visible = not screen.taskbar_widget.visible;
            end,
            {description = "toggle taskbar visibility", group = "taskbar"}
        )
    )

    root.keys(globalkeys)
end

function taskbar.setup()
    awful.screen.connect_for_each_screen(function(s)
        s.tasklist = icon_only_tasklist(s)

        local widget_width = s.geometry.width / 6
        local widget_height = 50

        s.taskbar_widget = wibox({
            type = "dock",

            screen = s,
            ontop = true,
            visible = false,

            border_width = 3,
            border_color = '#454545',

            bg = "#383838dd",

            width = widget_width,
            height = widget_height,
            x = s.geometry.width / 2 + s.geometry.x - widget_width / 2,
            y = s.geometry.height - widget_height,
        })

        s.taskbar_widget:setup({
            s.tasklist,
            layout  = wibox.layout.fixed.horizontal,
        })
    end)

    extend_global_keys()
end

return taskbar
