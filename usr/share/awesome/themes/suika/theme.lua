---------------------------
---------- Suika ----------
---------------------------

theme = {}

theme.font          = "lemon 7"
theme.taglist_font  = "lemon 7"

theme.bg_normal     = "#3f3f3f"
theme.bg_focus      = "#3f3f3f"
theme.bg_urgent     = "#3f3f3f"
theme.bg_minimize   = "#3f3f3f"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#cccaca"
theme.fg_focus      = "#a98d9b"
theme.fg_urgent     = "#d9bfc2"
theme.fg_minimize   = "#5d5d5d"

theme.border_width  = 1
theme.border_normal = "#3f3f3f"
theme.border_focus  = "#3f3f3f"
theme.border_marked = "#3f3f3f"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#3f3f3f"

-- Display the taglist squares
theme.taglist_squares_sel   = "/usr/share/awesome/themes/suika/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/suika/taglist/squarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/suika/submenu.png"
theme.menu_height = 15
theme.menu_width  = 80

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#3f3f3f"


-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/suika/titlebar/close.png"
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/suika/titlebar/close.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/suika/titlebar/ontop.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/suika/titlebar/ontop.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/suika/titlebar/ontop.png"
theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/suika/titlebar/ontop.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/suika/titlebar/sticky.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/suika/titlebar/sticky.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/suika/titlebar/sticky.png"
theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/suika/titlebar/sticky.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/suika/titlebar/floating.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/suika/titlebar/floating.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/suika/titlebar/floating.png"
theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/suika/titlebar/floating.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/suika/titlebar/maximised.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/suika/titlebar/maximised.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/suika/titlebar/maximised.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/suika/titlebar/maximised.png"

theme.titlebar_minimize_button_normal_inactive = "/usr/share/awesome/themes/suika/titlebar/minimise.png"
theme.titlebar_minimize_button_focus_inactive  = "/usr/share/awesome/themes/suika/titlebar/minimise.png"
theme.titlebar_minimize_button_normal_active = "/usr/share/awesome/themes/suika/titlebar/minimise.png"
theme.titlebar_minimize_button_focus_active  = "/usr/share/awesome/themes/suika/titlebar/minimise.png"


-- theme.wallpaper = "/home/akarin/Pictures/Flandre C.png"
theme.wallpaper = "/home/akarin/Pictures/flat.png"

theme.layout_fairh = "/usr/share/awesome/themes/suika/layouts/fairh.png"
theme.layout_fairv = "/usr/share/awesome/themes/suika/layouts/fairv.png"
theme.layout_floating  = "/usr/share/awesome/themes/suika/layouts/floating.png"
theme.layout_magnifier = "/usr/share/awesome/themes/suika/layouts/magnifier.png"
theme.layout_max = "/usr/share/awesome/themes/suika/layouts/max.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/suika/layouts/fullscreen.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/suika/layouts/tilebottom.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/suika/layouts/tileleft.png"
theme.layout_tile = "/usr/share/awesome/themes/suika/layouts/tile.png"
theme.layout_tiletop = "/usr/share/awesome/themes/suika/layouts/tiletop.png"
theme.layout_spiral  = "/usr/share/awesome/themes/suika/layouts/spiral.png"
theme.layout_dwindle = "/usr/share/awesome/themes/suika/layouts/dwindle.png"


theme.layout_termfair    = "/usr/share/awesome/themes/suika/layouts/fairh.png"
theme.layout_cascade     = "/usr/share/awesome/themes/suika/layouts/cascadew.png"
theme.layout_cascadetile = "/usr/share/awesome/themes/suika/layouts/cascadetilew.png"
theme.layout_centerwork  = "/usr/share/awesome/themes/suika/layouts/magnifier.png"
theme.layout_uselessfair  = "/usr/share/awesome/themes/suika/layouts/fairv.png"
theme.layout_uselessfairh  = "/usr/share/awesome/themes/suika/layouts/fairh.png"
theme.layout_uselesspiral  = "/usr/share/awesome/themes/suika/layouts/spiral.png"
theme.layout_uselessdwindle  = "/usr/share/awesome/themes/suika/layouts/dwindle.png"
theme.layout_uselesstile  = "/usr/share/awesome/themes/suika/layouts/tile.png"
theme.layout_uselesstiletop  = "/usr/share/awesome/themes/suika/layouts/tiletop.png"
theme.layout_uselesstilebottom  = "/usr/share/awesome/themes/suika/layouts/tilebottom.png"
theme.layout_uselesstileleft  = "/usr/share/awesome/themes/suika/layouts/tileleft.png"


theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil
theme.tasklist_disable_icon = true

theme.useless_gap_width = "8"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
