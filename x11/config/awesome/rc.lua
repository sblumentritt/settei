local awful = require("awful")
local naughty = require("naughty")

require("awful.autofocus")

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error",
        function (err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end

            in_error = true

            naughty.notify({
                preset = naughty.config.presets.critical,
                title = "Runtime Error",
                text = tostring(err),
            })

            in_error = false
        end
    )
end

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

require("core.theme").setup()
require("core.statusbar").setup()

require("core.bindings").setup()
require("core.rules").setup()
require("core.signals").setup()

require("modules.taskbar").setup()
