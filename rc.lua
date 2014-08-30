 -- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local vain    = require("vain")
local lain    = require("lain")
local drop    = require("scratchdrop")

vain.widgets.terminal = "urxvt"

-- awful.util.spawn_with_shell("unagi &")
-- awful.util.spawn_with_shell("cairo-compmgr &")
-- awful.util.spawn_with_shell("compton &")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/usr/share/awesome/themes/suika/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt" or "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
--    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier,
--    lain.layout.termfair,
--    lain.layout.centerfair,
--    lain.layout.cascade,
--    lain.layout.cascadetile,
--    lain.layout.centerwork,
    lain.layout.uselesstile,
    lain.layout.uselesstile.left,
    lain.layout.uselesstile.bottom,
    lain.layout.uselesstile.top,
--    lain.layout.uselessfair,
--    lain.layout.uselessfair.horizontal,
--    lain.layout.uselesspiral,
--    lain.layout.uselesspiral.dwindle,
--    lain.layout.uselesstile.left,
--    lain.layout.uselesstile.top,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.max
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
tags = {
   names = { "HOME", "WEB", "TERM", "MEDIA" },
   layout = { layouts[1], layouts[1], layouts[1], layouts[1] }
}
for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

oyasumi = {
   { "suspend", "pm-suspend" },
   { "hibernate", "pm-hibernate" },
   { "reboot", "shutdown -r now" },
   { "shutdown", "shutdown -h now" }
}

commandlist = {
   { "screenshot", sscrot },
   { "record", "byzanz-record --delay 5 -d 10 record.gif" }
}

games = {
   { "steam", "steam -no-dwrite -dev" },
--   { "2048.c", "exec 2048" },
   { "Minecraft", "Minecraft" }
} 

sscrot = {
   { "now", "scrot" },
   { "5 seconds", "scrot --delay 5 -q 100" },
   { "10 seconds", "scrot --delay 10 -q 100" },
   { "select area", "scrot -s -q 100"},
   { "window", "scrot -bs -q 100" }
}


application = {
   { "browser", "dbus-launch firefox-nightly" },
   { "files", "nautilus" },
   { "editor", "gedit" },
   { "paint", "mypaint" },
   { "image", "viewnior" },
   { "video", "exec ampv" },
   { "voice", "teamspeak3" },
   { "steam", "steam -no-dwrite -dev" }
}

mymainmenu = awful.menu({ items = { { "application", application },
                                    { "command", commandlist },
                                    { "terminal", terminal },
                                    { "subarashii", myawesomemenu },
                                    
                                    { "oyasumi", oyasumi }
                                  }
                        })

mylauncher = awful.widget.launcher({ menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

separator = wibox.widget.textbox()
separator.text = " "


markup = lain.util.markup
blue = "#A98D9B"


----- WEATHER


-- Weather widget
weatherwidget = wibox.widget.textbox()
weather_t = awful.tooltip({ objects = { weatherwidget },})

vicious.register(weatherwidget, vicious.widgets.weather,
                function (widget, args)
                    weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windkmh}"] .. "km/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
                    return args["{sky}"]..' '.. args["{tempc}"] .. " C "
                end, 60, "KNFG")
                --'1800': check every 30 minutes.
                --'CYUL': the Montreal ICAO code.
weathericon = wibox.widget.imagebox()
weathericon:set_image("/usr/share/awesome/themes/suika/widgets/weather.png")




-- TEMP
	-- Core Temp
	tempwidget = wibox.widget.textbox()
	vicious.register(tempwidget, vicious.widgets.thermal, "$1 C ", 1, {"coretemp.0", "core", "0"})
	-- Icon
	tempicon = wibox.widget.imagebox()
	tempicon:set_image("/usr/share/awesome/themes/suika/widgets/temp.png")






-- MPD
-- Initialize widget
-- mpdwidgetold = wibox.widget.textbox()
-- Register widget
-- vicious.register(mpdwidgetold, vicious.widgets.mpd,
--    function (mpdwidgetold, args)
--        if args["{state}"] == "Stop" then 
--            return "- "
--        else 
--            return args["{Artist}"]..' - '.. args["{Title}"]..' '
--        end
--    end, 1)
mpdicon = wibox.widget.imagebox()
mpdicon:set_image("/usr/share/awesome/themes/suika/widgets/note.png")





-- MPD
mpd_icon = wibox.widget.imagebox()
mpd_icon:set_image("/usr/share/awesome/themes/suika/widgets/mpd.png")
prev_icon = wibox.widget.imagebox()
prev_icon:set_image("/usr/share/awesome/themes/suika/widgets/prev.png")
next_icon = wibox.widget.imagebox()
next_icon:set_image("/usr/share/awesome/themes/suika/widgets/next.png")
stop_icon = wibox.widget.imagebox()
stop_icon:set_image("/usr/share/awesome/themes/suika/widgets/stop.png")
pause_icon = wibox.widget.imagebox()
pause_icon:set_image("/usr/share/awesome/themes/suika/widgets/pause.png")
play_pause_icon = wibox.widget.imagebox()
play_pause_icon:set_image("/usr/share/awesome/themes/suika/widgets/play.png")

mpdwidget = lain.widgets.mpd({
    settings = function ()
        if mpd_now.state == "play" then
--            mpd_now.artist = mpd_now.artist:upper():gsub("&.-;", string.lower)
            mpd_now.artist = mpd_now.artist
            mpd_now.title = mpd_now.title
            widget:set_markup(markup.font("Lemon 7", "")
                              .. markup.font("Lemon 7",
                              mpd_now.artist
                              .. " - " ..
                              mpd_now.title
                              .. markup.font("Lemon 7", " ")))
            play_pause_icon:set_image("/usr/share/awesome/themes/suika/widgets/pause.png")
        elseif mpd_now.state == "pause" then
            widget:set_markup(markup.font("Lemon 7", "") ..
                              markup.font("Lemon 7", "Paused") ..
                              markup.font("Lemon 7", " "))
            play_pause_icon:set_image("/usr/share/awesome/themes/suika/widgets/play.png")
        else
            widget:set_markup("- ")
            play_pause_icon:set_image("/usr/share/awesome/themes/suika/widgets/play.png")
        end
    end
})

musicwidget = wibox.widget.background()
musicwidget:set_widget(mpdwidget)
musicwidget:set_bgimage(beautiful.widget_bg)
musicwidget:buttons(awful.util.table.join(awful.button({ }, 1,
function () awful.util.spawn_with_shell(musicplr) end)))
mpd_icon:buttons(awful.util.table.join(awful.button({ }, 1,
function () awful.util.spawn_with_shell(musicplr) end)))
prev_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.util.spawn_with_shell("mpc prev || ncmpcpp prev || ncmpc prev || pms prev")
    mpdwidget.update()
end)))
next_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.util.spawn_with_shell("mpc next || ncmpcpp next || ncmpc next || pms next")
    mpdwidget.update()
end)))
stop_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    play_pause_icon:set_image(beautiful.play)
    awful.util.spawn_with_shell("mpc stop || ncmpcpp stop || ncmpc stop || pms stop")
    mpdwidget.update()
end)))
play_pause_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.util.spawn_with_shell("mpc toggle || ncmpcpp toggle || ncmpc toggle || pms toggle")
    mpdwidget.update()
end)))





-- ALSA volume bar
lainalsabar = lain.widgets.alsabar({
    timeout = 1,
    ticks = false,
    width = 50,
    height = 2,
    channel = "PCM",
    step = "5%",
    colors = {
        background = "#5d5d5d",
        unmute = "#cccaca",
        mute = "#a98d9b"
    },
    notifications = {
        font = "Lemon",
        font_size = "7",
        bar_size = 14
    }
})

alsamargin = wibox.layout.margin(lainalsabar.bar, 5, 8, 50)
wibox.layout.margin.set_top(alsamargin, 6)
wibox.layout.margin.set_bottom(alsamargin, 6)
lainvolumewidget = wibox.widget.background()
lainvolumewidget:set_widget(alsamargin)
-- volumewidget:set_bgimage(beautiful.widget_bg)



-- Battery
lainbattery = lain.widgets.bat({
    timeout = 10,
    notify = "on",
    settings = function()
        bat_header = ""
        bat_p = bat_now.perc .. "% "

        if bat_now.status == "Not present" then
            bat_header = ""
            bat_p = "N/A "
        end

        if bat_now.status == "Charging" then
            bat_header = ""
            bat_p = "" .. bat_now.perc .. "% "

        end

        if bat_now.status == "Discharging" then
            bat_header = ""
            bat_p = "" .. bat_now.perc .. "% "

        end

bat_notification_low_preset = {
        text = "Battery Low\n15% Remaining",
        timeout = 12,
        fg = "#cccaca",
        bg = "#3f3f3f"
}

bat_notification_critical_preset = {
        text = "Battery Critical\n5% Remaining",
        timeout = 12,
        fg = "#cccaca",
        bg = "#3f3f3f"
}


        widget:set_markup(markup(blue, bat_header) .. bat_p)
    end
})


-- ALSA volume
-- lainvolicon = wibox.widget.imagebox(beautiful.widget_vol)
lainvolume = lain.widgets.alsa({
    timeout = 1,
    channel = "PCM",
    settings = function()
--        if volume_now.status == "off" then
--            volicon:set_image(beautiful.widget_vol_mute)
--        elseif tonumber(volume_now.level) == 0 then
--            volicon:set_image(beautiful.widget_vol_no)
--        elseif tonumber(volume_now.level) <= 50 then
--            volicon:set_image(beautiful.widget_vol_low)
--        else
--            volicon:set_image(beautiful.widget_vol)
--        end
--
        widget:set_text("" .. volume_now.level .. "% ")
    end
})






datewidget = wibox.widget.textbox()
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%Y.%m.%d %H:%M ", 1)

dateicon = wibox.widget.imagebox()
dateicon:set_image("/usr/share/awesome/themes/suika/widgets/clock.png")



volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume, "$1% ", 1, "PCM")

volicon = wibox.widget.imagebox()
volicon:set_image("/usr/share/awesome/themes/suika/widgets/vol.png")




-- MPD
--mpdwidget = wibox.widget.textbox()
--vicious.register(mpdwidget, vicious.widgets., "{Artist} - {Title} ")

--mpdicon = wibox.widget.imagebox()
--mpdicon:set_image("/usr/share/awesome/themes/suika/widgets/note.png")




-- CPU Usage
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "$1% ", 1)

cpuicon = wibox.widget.imagebox()
cpuicon:set_image("/usr/share/awesome/themes/suika/widgets/cpu.png")



-- RAM Usage
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "$1% ", 1)

memicon = wibox.widget.imagebox()
memicon:set_image("/usr/share/awesome/themes/suika/widgets/mem.png")


-- Battery
battwidget = wibox.widget.textbox()
-- vicious.register(battwidget, vicious.widgets.bat, "$1$2% ", 1, 'BAT0')
vicious.register(battwidget, vicious.widgets.bat, "$2% ", 1, 'BAT0')

batticon = wibox.widget.imagebox()
batticon:set_image("/usr/share/awesome/themes/suika/widgets/bat.png")







-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height = "14",  screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mylayoutbox[s])
    left_layout:add(mypromptbox[s])
--    left_layout:add(mytasklist[s])
--    left_layout:add(prev_icon)
--    left_layout:add(stop_icon)
--    left_layout:add(play_pause_icon)
--    left_layout:add(next_icon)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
--    if s == 1 then right_layout:add(wibox.widget.systray()) end

    right_layout:add(mpdicon)
--    right_layout:add(mpdwidget)
    right_layout:add(musicwidget)

    right_layout:add(weathericon)
    right_layout:add(weatherwidget)
--    right_layout:add(tempicon)
--    right_layout:add(tempwidget)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(volicon)
    right_layout:add(lainvolume)
--    right_layout:add(volwidget)
--    right_layout:add(lainvolumewidget)   
    right_layout:add(batticon)
--    right_layout:add(lainbattery)
    right_layout:add(battwidget)
    right_layout:add(dateicon)
    right_layout:add(datewidget)
--    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
--    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
--    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
--    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
--    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
--    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
--    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
--    awful.key({ modkey,           }, "Tab",
--        function ()
--            awful.client.focus.history.previous()
--            if client.focus then
--                client.focus:raise()
--            end
--        end),


    -- Dropdown terminal
    awful.key({ modkey, }, "z", function () drop("urxvt -name urxvt_drop -e tmux", "top", "left", 374, 104, true) end),

--    awful.key({ modkey,           }, "z",      function () drop(terminal, "top", "center", 1, 0.5) end),

    -- Widgets popups
--    awful.key({ altkey, }, "c", function () lain.widgets.calendar:show(7) end),
--    awful.key({ altkey, }, "w", function () yawn.show(7) end),




awful.key({ modkey, "Shift"   }, "r",
          function ()
              awful.prompt.run({ prompt = "Run in terminal: " },
                  mypromptbox[mouse.screen].widget,
                  function (...) awful.util.spawn(terminal .. " -e " .. ...) end,
                  awful.completion.shell,
                  awful.util.getdir("cache") .. "/history")
          end),



-- ...
    awful.key({ modkey      , "Shift"      }, "m", function ()
        awful.prompt.run({ prompt = "Calculate: " }, mypromptbox[mouse.screen].widget,
            function (expr)
                local result = awful.util.eval("return (" .. expr .. ")")
                naughty.notify({ text = expr .. " = " .. result, timeout = 10 })
            end
        )
    end),






    -- all minimized clients are restored 
    awful.key({ modkey, "Shift"   }, "n", 
        function()
            local tag = awful.tag.selected()
                for i=1, #tag:clients() do
                    tag:clients()[i].minimized=false
                  
            end
        end),




    -- Show Menu
--    awful.key({ modkey }, "w",
--        function ()
--            mymainmenu:show({ keygrabber = true })
--        end),


-- On the fly useless gaps change
--    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end),
--    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx( 1) end),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey, }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
--    awful.key({ altkey, "Shift" }, "l", function () awful.tag.incmwfact( 0.05) end),
--    awful.key({ altkey, "Shift" }, "h", function () awful.tag.incmwfact(-0.05) end),
--    awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end),
--    awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster( 1) end),
--    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),
--    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1) end),
--    awful.key({ modkey, }, "space", function () awful.layout.inc(layouts, 1) end),
--    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
--    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
    -- Menubar
 --   awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "Return",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),



awful.key({ modkey, "Shift" }, "t", function (c)
    -- toggle titlebar
    if (c:titlebar_top():geometry()['height'] > 0) then
        awful.titlebar(c, {size = 0})
    else
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )
 
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
--        left_layout:add(awful.titlebar.widget.iconwidget(c))
--        left_layout:buttons(buttons)
        left_layout:add(awful.titlebar.widget.floatingbutton(c))
        left_layout:add(awful.titlebar.widget.stickybutton(c))
        left_layout:add(awful.titlebar.widget.ontopbutton(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.minimizebutton (c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))
 
        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
--        middle_layout:add(title)
        middle_layout:buttons(buttons)
 
        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)
 
        awful.titlebar(c, {size = 12}):set_widget(layout)
    end
end)






)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     size_hints_honor = false,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "qiv" },
      properties = { floating = false } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
--        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)
        left_layout:add(awful.titlebar.widget.ontopbutton(c))
        left_layout:add(awful.titlebar.widget.stickybutton(c))
        left_layout:add(awful.titlebar.widget.floatingbutton(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.minimizebutton (c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
--        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c, {size = 12}):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
