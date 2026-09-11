-- Hyprland config (Lua, 0.55+). Live-edited via an out-of-store symlink from
-- home.nix, so changes here take effect on the next Hyprland reload/restart
-- without running `nixos-rebuild` or `home-manager switch`.
--
-- API reference: https://wiki.hypr.land/Configuring/Start/
-- Shipped example: <hyprland-pkg>/share/hypr/hyprland.lua

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


local terminal = "ghostty"

local mainMod  = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
