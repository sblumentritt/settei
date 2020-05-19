#!/bin/sh

# --------------------------------------
# source .bashrc
# --------------------------------------
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# --------------------------------------
# define qt platform theme
# --------------------------------------
export QT_QPA_PLATFORMTHEME="qt5ct"

# --------------------------------------
# start music daemon
# --------------------------------------
if [ ! -f /etc/profile.d/work.sh ]; then
    [ ! -s "$HOME/.config/mpd/pid" ] && mpd
fi

# --------------------------------------
# start ssh-agent for git
# --------------------------------------
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh_agent.info"
fi

if [ ! "$SSH_AUTH_SOCK" ]; then
    eval "$(cat $XDG_RUNTIME_DIR/ssh_agent.info)"
fi

# --------------------------------------
# configure gtk3 manually for wayland
# because the developer are silly
# and don't read values from the config file
# -> config file still needs to be available
#    e.g. for chromium
# --------------------------------------
gnome_interface_schema="org.gnome.desktop.interface"
gsettings set ${gnome_interface_schema} gtk-theme "Pop-dark"
gsettings set ${gnome_interface_schema} icon-theme "Papirus-Dark"
gsettings set ${gnome_interface_schema} font-name "Lato 10"
gsettings set ${gnome_interface_schema} monospace-font-name "Source Code Pro 10"
gsettings set ${gnome_interface_schema} toolbar-style "text"
gsettings set ${gnome_interface_schema} toolbar-icons-size "small"
gsettings set ${gnome_interface_schema} cursor-theme "Adwaita"

# --------------------------------------
# start display server
# --------------------------------------
if [ "$(tty)" = "/dev/tty1" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    if [ -z $WAYLAND_DISPLAY ]; then
        # use wayland backend in Qt
        # export QT_QPA_PLATFORM=wayland-egl
        # export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

        # use xcb backend in Qt (wayland support is not stable enough)
        export QT_QPA_PLATFORM=xcb

        # use wayland backend in SDL
        export SDL_VIDEODRIVER=wayland

        # start sway
        exec sway 2> $HOME/.cache/sway.log
    fi
fi
