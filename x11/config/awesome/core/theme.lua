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

    config.tasklist_fg_normal = color.gray
    config.tasklist_fg_focus = color.foreground

    config.tasklist_bg_normal = color.gray
    config.tasklist_bg_focus = color.green
    config.tasklist_bg_urgent = color.red
    config.tasklist_bg_minimize = color.yellow

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
    local custom_icon_path = os.getenv("XDG_CONFIG_HOME") .. "/awesome/icons"

    config.titlebar_close_button_normal = custom_icon_path .. "/titlebar/close_normal.svg"
    config.titlebar_close_button_focus = custom_icon_path .. "/titlebar/close_focus.svg"
    config.titlebar_close_button_focus_hover = custom_icon_path .. "/titlebar/close_focus_hover.svg"

    config.titlebar_minimize_button_normal = custom_icon_path .. "/titlebar/minimize_normal.svg"
    config.titlebar_minimize_button_focus = custom_icon_path .. "/titlebar/minimize_focus.svg"
    config.titlebar_minimize_button_focus_hover = custom_icon_path .. "/titlebar/minimize_focus_hover.svg"

    config.titlebar_ontop_button_normal_inactive = custom_icon_path .. "/titlebar/ontop_normal_inactive.svg"
    config.titlebar_ontop_button_focus_inactive = custom_icon_path .. "/titlebar/ontop_focus_inactive.svg"
    config.titlebar_ontop_button_focus_inactive_hover = custom_icon_path .. "/titlebar/ontop_focus_inactive_hover.svg"

    config.titlebar_ontop_button_normal_active = custom_icon_path .. "/titlebar/ontop_normal_active.svg"
    config.titlebar_ontop_button_focus_active = custom_icon_path .. "/titlebar/ontop_focus_active.svg"
    config.titlebar_ontop_button_focus_active_hover = custom_icon_path .. "/titlebar/ontop_focus_active_hover.svg"

    -- define the icon theme for application icons. if not set then the icons
    -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
    config.icon_theme = nil

    -- variables set for theming notifications
    config.notification_font         = "Source Code Pro 9"
    config.notification_width        = dpi(270)
    config.notification_max_height   = dpi(500)
    config.notification_margin       = dpi(20)
    config.notification_border_width = config.border_width
    config.notification_border_color = color.dark_gray

    naughty.config.padding               = dpi(15)
    naughty.config.spacing               = dpi(7)
    naughty.config.defaults.timeout      = 10
    naughty.config.defaults.border_width = config.notification_border_width
    naughty.config.defaults.margin       = config.notification_margin
    naughty.config.defaults.title        = "System Notification"
    naughty.config.presets.low.fg        = color.green
    naughty.config.presets.critical.fg   = color.red
    naughty.config.presets.critical.bg   = color.background

    naughty.config.notify_callback = function (args)
        -- disable any kind of actions
        args.actions = nil

        -- disable any kind of icon
        args.icon = nil
        return args
    end

    beautiful.init(config)
end

return theme
