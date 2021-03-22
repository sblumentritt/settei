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
[ ! -s "$HOME/.config/mpd/pid" ] && mpd

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
# start gpg-agent for git
# --------------------------------------
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

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
backend="x11" # [wayland/x11]

if [ "$(tty)" = "/dev/tty1" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    if [ "${backend}" = "x11" ]; then
        if [ -z $DISPLAY ]; then
            # start xserver
            exec startx "$XDG_CONFIG_HOME/X11/xinitrc"
        fi
    elif [ "${backend}" = "wayland" ]; then
        if [ -z $WAYLAND_DISPLAY ]; then
            # use wayland backend in Qt
            # export QT_QPA_PLATFORM=wayland-egl
            # export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

            # use xcb backend in Qt (wayland support is not stable enough)
            export QT_QPA_PLATFORM=xcb

            # use wayland backend in SDL
            export SDL_VIDEODRIVER=wayland

            # lie about the window manager mode (fixes Jetbrain IDE's)
            export _JAVA_AWT_WM_NONREPARENTING=1

            # start sway
            exec sway 2> $HOME/.cache/sway.log
        fi
    fi
fi
