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
    vicious.register(clock_info, vicious.widgets.date, "%I:%M %p")

    local month_calendar = awful.widget.calendar_popup.month()
    month_calendar:attach(clock_info, "tr", {on_hover = false})

    local memory_info = wibox.widget.textbox()
    vicious.register(memory_info, vicious.widgets.mem, "$2 MB/$3 MB", 5)

    local load_info = wibox.widget.textbox()
    vicious.register(load_info, vicious.widgets.uptime, "$4 $5 $6", 5)

    local update_info = wibox.widget.textbox()
    vicious.register(update_info, vicious.widgets.pkg, "$1", 300, "Arch C")

    local music_info = wibox.widget.textbox()
    vicious.register(
        music_info,
        vicious.widgets.mpd,
        function(widget, args)
            if args["{state}"] == "N/A" or args["{state}"] == "Stop" then
                return "[?]"
            else
                local symbol = "[ ]"

                if args["{state}"] == "Play" then
                    symbol = "[>]"
                elseif args["{state}"] == "Pause" then
                    symbol = "[=]"
                end

                return ('%s %s - %s'):format(symbol, args["{Artist}"], args["{Title}"])
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
            buttons = taglist_buttons,
        }

        -- create the wibar
        s.bar = awful.wibar({position = "top", screen = s, height = 35})

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
            separator,
            {
                -- right widgets
                layout = wibox.layout.fixed.horizontal,
                separator,

                music_info,
                spacer,

                update_info,
                spacer,

                load_info,
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
