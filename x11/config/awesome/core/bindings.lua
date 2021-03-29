-- @module core.bindings
local bindings = {}

local gears = require("gears")
local awful = require("awful")

local function set_global_mouse_buttons()
    -- root.buttons(gears.table.join(
    --     awful.button({ }, 3, function () mymainmenu:toggle() end),
    --     awful.button({ }, 4, awful.tag.viewnext),
    --     awful.button({ }, 5, awful.tag.viewprev)
    -- ))
end

local function set_global_keys()
    -- define some standard programs
    local terminal = "alacritty"
    local browser = "firefox"
    local screen_locker = "xsecurelock"

    -- define a table with all keys
    local globalkeys = gears.table.join(
        awful.key({modkey}, "Right",
            function ()
                awful.client.focus.byidx(1)
            end,
            {description = "focus next by index", group = "client"}
        ),
        awful.key({modkey}, "Left",
            function ()
                awful.client.focus.byidx(-1)
            end,
            {description = "focus previous by index", group = "client"}
        ),

        awful.key({modkey, "Control"}, "Right",
            function()
                awful.screen.focus_relative(1)
            end,
            {description = "focus the next screen", group = "screen"}
        ),
        awful.key({modkey, "Control"}, "Left",
            function()
                awful.screen.focus_relative(-1)
            end,
            {description = "focus the previous screen", group = "screen"}
        ),

        -- Layout manipulation
        awful.key({modkey, "Shift"}, "Right",
            function ()
                awful.client.swap.byidx(1)
            end,
            {description = "swap with next client by index", group = "client"}
        ),
        awful.key({modkey, "Shift"}, "Left",
            function ()
                awful.client.swap.byidx(-1)
            end,
            {description = "swap with previous client by index", group = "client"}
        ),

        awful.key({modkey}, "l",
            function()
                awful.tag.incmwfact(0.05)
            end,
            {description = "increase master width factor", group = "layout"}
        ),
        awful.key({modkey}, "h",
            function()
                awful.tag.incmwfact(-0.05)
            end,
            {description = "decrease master width factor", group = "layout"}
        ),

        -- Standard program
        awful.key({modkey}, "Return",
            function ()
                awful.spawn(terminal)
            end,
            {description = "open a terminal", group = "launcher"}
        ),
        awful.key({modkey}, "F2",
            function ()
                awful.spawn(browser)
            end,
            {description = "open a browser", group = "launcher"}
        ),
        awful.key({modkey}, "9",
            function ()
                awful.spawn(screen_locker)
            end,
            {description = "lock the screen", group = "launcher"}
        ),
        awful.key({modkey}, "d",
            function ()
                local launcher_exe = terminal ..
                    " --class launcher" ..
                    " --option window.dimensions.columns=40 --option window.dimensions.lines=7" ..
                    " -e launcher.sh -e"
                awful.spawn(launcher_exe)
            end,
            {description = "open a launcher for executables", group = "launcher"}
        ),
        awful.key({modkey, "Shift"}, "d",
            function ()
                local launcher_doc = terminal ..
                    " --class launcher" ..
                    " --option window.dimensions.columns=90 --option window.dimensions.lines=7" ..
                    " -e launcher.sh -d"

                awful.spawn(launcher_doc)
            end,
            {description = "open a launcher for documents", group = "launcher"}
        ),

        awful.key({modkey}, "F12",
            function ()
                local file_path = "/tmp/" .. os.date("%Y%m%d") .. "_" .. os.time() .. "_screenshot.png"
                awful.spawn("maim -o -u -f png -s -c 0.4,0.4,0.4,0.5 -b 10000 " .. file_path)
            end,
            {description = "take a screenshot (select window / draw selection)", group = "launcher"}
        ),

        awful.key({modkey, "Shift"}, "r",
            awesome.restart,
            {description = "reload awesome", group = "awesome"}
        ),
        awful.key({modkey, "Shift"}, "c",
            awesome.quit,
            {description = "quit awesome", group = "awesome"}
        )
    )

    -- Bind key numbers to tags
    for i = 1, 4 do
        globalkeys = gears.table.join(globalkeys,
            -- View tag only
            awful.key({modkey}, "#" .. i + 9,
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                       tag:view_only()
                    end
                end,
                {description = "view tag #"..i, group = "tag"}
            ),
            -- Move client to tag
            awful.key({modkey, "Shift"}, "#" .. i + 9,
                function ()
                  if client.focus then
                      local tag = client.focus.screen.tags[i]
                      if tag then
                          client.focus:move_to_tag(tag)
                      end
                 end
                end,
                {description = "move focused client to tag #"..i, group = "tag"}
            )
        )
    end

    -- Set keys
    root.keys(globalkeys)
end

function bindings.client_mouse_buttons()
    return gears.table.join(
        awful.button({}, 1,
            function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
            end
        ),
        awful.button({modkey}, 1,
            function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.move(c)
            end
        ),
        awful.button({modkey}, 3,
            function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.resize(c)
            end
        )
    )
end

function bindings.client_mouse_buttons_jetbrains()
    return gears.table.join(
        awful.button({modkey}, 1, awful.mouse.client.move),
        awful.button({modkey}, 3, awful.mouse.client.resize)
    )
end

function bindings.client_keys()
    return gears.table.join(
        awful.key({modkey, "Shift"}, "q",
            function (c)
                c:kill()
            end,
            {description = "close", group = "client"}
        ),

        awful.key({modkey, "Shift"}, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}
        ),

        awful.key({modkey}, "f",
            function (c)
                c.floating = not c.floating

                -- toggle titlebar depending on the floating value
                if c.floating then
                    awful.titlebar.show(c)

                    -- resize client if it is to large
                    local client_max_width = c.screen.geometry.width - 80
                    local client_max_height = c.screen.geometry.height - 100

                    if c.width >= client_max_width  then
                        c.width = client_max_width
                    end

                    if c.height >= client_max_height then
                        c.height = client_max_height
                    end
                else
                    awful.titlebar.hide(c)
                end

                -- center client on current screen
                c.x =  c.screen.geometry.width / 2 + c.screen.geometry.x - c.width / 2
                c.y = c.screen.geometry.height / 2 - c.screen.geometry.y - c.height / 2
            end,
            {description = "toggle floating", group = "client"}
        ),

        awful.key({modkey, "Shift"}, "t",
            function (c)
                awful.titlebar.toggle(c)
            end,
            {description = "toggle title bar", group = "client"}
        ),

        awful.key({modkey}, "n",
            function (c)
                c:move_to_screen(c.screen.index + 1)
                awful.screen.focus_relative(-1)
            end,
            {description = "move client to next screen (to the right)", group = "client"}
        ),
        awful.key({modkey}, "p",
            function (c)
                c:move_to_screen(c.screen.index - 1)
                awful.screen.focus_relative(1)
            end,
            {description = "move client to previous screen (to the left)", group = "client"}
        )
    )
end

function bindings.setup()
    set_global_mouse_buttons()
    set_global_keys()
end

return bindings
