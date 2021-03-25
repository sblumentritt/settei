-- @module core.theme
local theme = {}

local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local themes_path = require("gears.filesystem").get_themes_dir()

function theme.setup()
    local color = {
        background   = "#383838",
        foreground   = "#e5dbd0",
        dark_gray    = "#454545",
        red          = "#da7c72",
        green        = "#b8b48a",
        orange       = "#dfa883",
        blue         = "#93b3a3",
        magenta      = "#cc9999",
        cyan         = "#9fb193",
        bright_white = "#f2e7e0",
        gray         = "#998f85",
        yellow       = "#f7d0a2"
    }

    local config = {}

    config.default_dir = themes_path .. "default"

    config.font = "Source Code Pro 10"

    config.useless_gap  = dpi(8)
    config.border_width = dpi(6)

    -- define color theme
    config.bg_normal   = color.background
    config.bg_focus    = config.bg_normal
    config.bg_urgent   = config.bg_normal
    config.bg_minimize = config.bg_normal
    config.bg_systray  = config.bg_normal

    config.fg_normal   = color.foreground
    config.fg_focus    = color.green
    config.fg_urgent   = color.orange
    config.fg_minimize = color.gray

    config.border_normal = color.gray
    config.border_focus  = color.dark_gray
    config.border_marked = config.fg_urgent

    config.taglist_bg_focus = color.green
    config.taglist_fg_focus = config.bg_normal

    config.taglist_bg_occupied = color.gray
    config.taglist_fg_occupied = config.bg_normal

    config.taglist_bg_urgent = config.fg_urgent
    config.taglist_fg_urgent = config.bg_normal

    config.taglist_bg_volatile = color.red
    config.taglist_fg_volatile = config.bg_normal

    config.titlebar_bg_normal = config.border_normal
    config.titlebar_bg_focus = config.border_focus
    config.titlebar_fg_focus = color.foreground

    config.tasklist_shape_border_color = color.gray
    config.tasklist_shape_border_color_focus = color.gray
    config.tasklist_shape_border_color_minimized = color.dark_gray

    config.tasklist_fg_normal = color.gray
    config.tasklist_fg_focus = color.foreground
    config.tasklist_bg_minimize = color.dark_gray

    -- use text for tasklist status information
    config.ocol                          = "<span color='" .. config.fg_minimize .. "'>"
    config.tasklist_sticky               = config.ocol .. "(S) </span>"
    config.tasklist_ontop                = config.ocol .. "(T) </span>"
    config.tasklist_floating             = config.ocol .. "(F) </span>"
    config.tasklist_above                = config.ocol .. "(A) </span>"
    config.tasklist_below                = config.ocol .. "(B) </span>"
    config.tasklist_maximized            = config.ocol .. "(M) </span>"
    config.tasklist_maximized_horizontal = config.ocol .. "(Mh) </span>"
    config.tasklist_maximized_vertical   = config.ocol .. "(Mv) </span>"
    config.tasklist_disable_icon         = true

    -- define text view of layouts
    config.layout_txt_tile       = "[t]"
    config.layout_txt_tileleft   = "[l]"
    config.layout_txt_tilebottom = "[b]"
    config.layout_txt_tiletop    = "[tt]"
    config.layout_txt_fairv      = "[fv]"
    config.layout_txt_fairh      = "[fh]"
    config.layout_txt_spiral     = "[s]"
    config.layout_txt_dwindle    = "[d]"
    config.layout_txt_max        = "[m]"
    config.layout_txt_fullscreen = "[F]"
    config.layout_txt_magnifier  = "[M]"
    config.layout_txt_floating   = "[*]"

    -- variables set for theming notifications
    config.notification_font         = "Source Code Pro 9"
    config.notification_max_width    = dpi(270)
    config.notification_max_height   = dpi(500)
    config.notification_margin       = dpi(20)
    config.notification_border_width = dpi(6)
    config.notification_border_color = color.dark_gray

    -- variables set for theming the menu:
    config.menu_height       = dpi(30)
    config.menu_width        = dpi(400)
    config.menu_font         = "Source Code Pro 10"
    config.menu_border_width = dpi(3)
    config.menu_border_color = color.dark_gray
    config.menu_bg_focus     = color.dark_gray
    config.menu_fg_focus     = color.foreground

    -- variables set for theming the calendar:
    config.calendar_spacing = dpi(10)
    config.calendar_week_numbers = true
    config.calendar_start_sunday = false

    config.calendar_month_border_color = color.dark_gray

    config.calendar_header_border_width = 0

    config.calendar_weekday_padding = dpi(5)
    config.calendar_weekday_border_width = 0
    config.calendar_weekday_fg_color = color.gray

    config.calendar_weeknumber_padding = config.calendar_weekday_padding
    config.calendar_weeknumber_border_width = config.calendar_weekday_border_width
    config.calendar_weeknumber_fg_color = config.calendar_weekday_fg_color

    config.calendar_normal_padding = config.calendar_weekday_padding
    config.calendar_normal_border_width = config.calendar_weekday_border_width

    config.calendar_focus_padding = config.calendar_weekday_padding
    config.calendar_focus_border_width = config.calendar_weekday_border_width
    config.calendar_focus_fg_color = color.background
    config.calendar_focus_bg_color = color.green

    -- define the image to load
    config.titlebar_close_button_normal = config.default_dir .. "/titlebar/close_normal.png"
    config.titlebar_close_button_focus  = config.default_dir .. "/titlebar/close_focus.png"

    config.titlebar_minimize_button_normal = config.default_dir .. "/titlebar/minimize_normal.png"
    config.titlebar_minimize_button_focus  = config.default_dir .. "/titlebar/minimize_focus.png"

    config.titlebar_ontop_button_normal_inactive = config.default_dir .. "/titlebar/ontop_normal_inactive.png"
    config.titlebar_ontop_button_focus_inactive  = config.default_dir .. "/titlebar/ontop_focus_inactive.png"

    config.titlebar_ontop_button_normal_active = config.default_dir .. "/titlebar/ontop_normal_active.png"
    config.titlebar_ontop_button_focus_active  = config.default_dir .. "/titlebar/ontop_focus_active.png"

    config.titlebar_sticky_button_normal_inactive = config.default_dir .. "/titlebar/sticky_normal_inactive.png"
    config.titlebar_sticky_button_focus_inactive  = config.default_dir .. "/titlebar/sticky_focus_inactive.png"

    config.titlebar_sticky_button_normal_active = config.default_dir .. "/titlebar/sticky_normal_active.png"
    config.titlebar_sticky_button_focus_active  = config.default_dir .. "/titlebar/sticky_focus_active.png"

    config.titlebar_floating_button_normal_inactive = config.default_dir .. "/titlebar/floating_normal_inactive.png"
    config.titlebar_floating_button_focus_inactive  = config.default_dir .. "/titlebar/floating_focus_inactive.png"

    config.titlebar_floating_button_normal_active = config.default_dir .. "/titlebar/floating_normal_active.png"
    config.titlebar_floating_button_focus_active  = config.default_dir .. "/titlebar/floating_focus_active.png"

    config.titlebar_maximized_button_normal_inactive = config.default_dir .. "/titlebar/maximized_normal_inactive.png"
    config.titlebar_maximized_button_focus_inactive  = config.default_dir .. "/titlebar/maximized_focus_inactive.png"

    config.titlebar_maximized_button_normal_active = config.default_dir .. "/titlebar/maximized_normal_active.png"
    config.titlebar_maximized_button_focus_active  = config.default_dir .. "/titlebar/maximized_focus_active.png"

    -- define the icon theme for application icons. if not set then the icons
    -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
    config.icon_theme = nil

    -- needed because notification settings are not properly applied
    naughty.config.padding               = dpi(15)
    naughty.config.spacing               = dpi(7)
    naughty.config.defaults.border_width = config.notification_border_width
    naughty.config.defaults.margin       = config.notification_margin
    naughty.config.presets.low.fg        = color.green
    naughty.config.presets.critical.fg   = color.red
    naughty.config.presets.critical.bg   = color.background

    beautiful.init(config)
end

return theme
