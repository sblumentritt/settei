-- @module core.statusbar
local statusbar = {}

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful")

-- writes a string representation of the current layout in a textbox widget
local function update_txt_layoutbox(s)
    local txt_l = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
    s.txt_layoutbox:set_text(txt_l)
end

function statusbar.setup()
    -- separator
    local separator = wibox.widget.textbox(' ')
    local spacer = wibox.widget.textbox(" :: ")

    -- vicious widgets
    local clock_info = wibox.widget.textbox()
    vicious.register(clock_info, vicious.widgets.date, "%I:%M %p", 5)

    local memory_info = wibox.widget.textbox()
    vicious.register(memory_info, vicious.widgets.mem, "$2 MB/$3 MB", 10)

    local load_info = wibox.widget.textbox()
    vicious.register(load_info, vicious.widgets.uptime, "$4", 10)

    local cpu_info = wibox.widget.textbox()
    vicious.register(cpu_info, vicious.widgets.cpu, "$1%", 10)

    local music_info = wibox.widget.textbox()
    vicious.register(
        music_info,
        vicious.widgets.mpd,
        function(widget, args)
            if args["{state}"] == "N/A" then
                return "[?]"
            else
                -- TODO: find out how the states are written and
                --       add the same handling as in the statusinfo.sh
                return ('%s %s - %s'):format(
                    args["{state}"], args["{Artist}"], args["{Title}"])
            end
        end,
        10,
        { nil, "127.0.0.1", "7070" }
    )

    local taglist_buttons = gears.table.join(
        awful.button({}, 1,
            function (t)
                t:view_only()
            end
        ),

        awful.button({}, 3, awful.tag.viewtoggle)
    )

    local tasklist_buttons = gears.table.join(
        awful.button({}, 1,
            function (c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal("request::activate", "tasklist", {raise = true})
                end
            end
        ),

        awful.button({}, 3,
            function ()
                awful.menu.client_list()
            end
        )
    )

    -- Create a wibox for each screen and add it
    awful.screen.connect_for_each_screen(function(s)
        -- Each screen has its own tag table.
        awful.tag({" 一 ", " 二 ", " 三 ", " 四 "}, s, awful.layout.layouts[1])

        -- Textual layoutbox
        s.txt_layoutbox = wibox.widget.textbox(
            beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))]
        )
        awful.tag.attached_connect_signal(s, "property::selected",
            function()
                update_txt_layoutbox(s)
            end
        )
        awful.tag.attached_connect_signal(s, "property::layout",
            function()
                update_txt_layoutbox(s)
            end
        )

        -- Define mouse bindings
        s.txt_layoutbox:buttons(gears.table.join(
                awful.button({}, 1, function() awful.layout.inc(1) end),
                awful.button({}, 3, function() awful.layout.inc(-1) end)
            )
        )

        -- Create a taglist widget
        s.taglist = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }

        -- create a tasklist widget
        s.tasklist = awful.widget.tasklist {
            screen   = s,
            filter   = awful.widget.tasklist.filter.currenttags,
            buttons  = tasklist_buttons,
            style   = {
                align = "center",
                shape_border_width = 1,
                shape  = gears.shape.rectangle,
            },
            layout = {
                spacing = 10,
                max_widget_size = 250,
                layout = wibox.layout.flex.horizontal,
            }
        }

        -- create the wibar
        s.bar = awful.wibar({position = "top", screen = s, height = 30})

        -- add widgets to the wibar
        s.bar:setup {
            layout = wibox.layout.align.horizontal,
            {
                -- left widgets
                layout = wibox.layout.fixed.horizontal,
                s.taglist,
                separator,

                s.txt_layoutbox,
                separator,
            },
            s.tasklist, -- middle widget
            {
                -- right widgets
                layout = wibox.layout.fixed.horizontal,
                separator,

                music_info,
                spacer,

                load_info,
                spacer,

                cpu_info,
                spacer,

                memory_info,
                spacer,

                clock_info,
                separator,
            }
        }
    end)
end

return statusbar
