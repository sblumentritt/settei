#!/bin/sh

# global variable
CONFIG_BASE_PATH="$HOME/workspace/configs/settei"

CONFIG_SHARED_PATH="${CONFIG_BASE_PATH}/shared"
CONFIG_WAYLAND_PATH="${CONFIG_BASE_PATH}/wayland"
CONFIG_X11_PATH="${CONFIG_BASE_PATH}/x11"

main() {
    printf "\nWhich display server should be configured? [wayland/x11/both] "
    read -r display_server_flag

    printf "\nSetup directories? [y/n] "
    read -r dir_flag

    if [ "${dir_flag}" = "y" ] || [ "${dir_flag}" = "Y" ]; then
        dir_setup_shared
    fi

    printf "\nSetup files? [y/n] "
    read -r file_flag

    if [ "${file_flag}" = "y" ] || [ "${file_flag}" = "Y" ]; then
        file_setup_shared

        if [ "${display_server_flag}" = "wayland" ] || [ "${display_server_flag}" = "both" ]; then
            file_setup_wayland
        fi

        if [ "${display_server_flag}" = "x11" ] || [ "${display_server_flag}" = "both" ]; then
            file_setup_x11
        fi
    fi

    printf "\nInstall packages (core/community/extra)? [y/n] "
    read -r package_flag

    if [ "${package_flag}" = "y" ] || [ "${package_flag}" = "Y" ]; then
        package_installation_shared

        if [ "${display_server_flag}" = "wayland" ] || [ "${display_server_flag}" = "both" ]; then
            package_installation_wayland
        fi

        if [ "${display_server_flag}" = "x11" ] || [ "${display_server_flag}" = "both" ]; then
            package_installation_x11
        fi
    fi

    printf "\nExternal packages (AUR/git)? [y/n] "
    read -r external_flag

    if [ "${external_flag}" = "y" ] || [ "${external_flag}" = "Y" ]; then
        external_packages_shared
    fi
}

dir_setup_shared() {
    # define character at which a string should be split
    local IFS=','
    local wanted_folder=""

    # create directories
    wanted_folder="workspace,documents,downloads,music,pictures,videos,.ssh,.cache"
    for folder in $wanted_folder; do
        mkdir -p "$HOME/$folder"
    done

    mkdir -p $HOME/downloads/torrents

    # required to not pollute the home dir
    mkdir -p "$HOME/.local/share/tig"
    mkdir -p "$HOME/.local/share/bash"
}

file_setup_shared() {
    # create required directories to link configs
    # --------------------------------------
    # define character at which a string should be split
    local IFS=','

    local wanted_folder="ranger,mpd,git,gtk-2.0,containers"
    for folder in $wanted_folder; do
        mkdir -p "$HOME/.config/$folder"
    done

    # link/copy dotfiles
    # --------------------------------------
    ln -sf "${CONFIG_SHARED_PATH}/config/.bashrc" $HOME/.bashrc
    ln -sf "${CONFIG_SHARED_PATH}/config/.profile" $HOME/.profile

    # remove possible available .bash_profile which blocks .profile
    if [ -f $HOME/.bash_profile ]; then
        rm -rf $HOME/.bash_profile
    fi

    printf "command script import %s/shared/config/lldb/settings.py\n" "${CONFIG_BASE_PATH}" \
        > $HOME/.lldbinit

    # link/copy configs
    # --------------------------------------
    ln -sf "${CONFIG_SHARED_PATH}/config/mpv" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/imv" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/tig" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/bash" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/nvim" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/tmux" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/iwyu" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/qt5ct" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/Kvantum" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/gtk-3.0" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/alacritty" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/fontconfig" $HOME/.config/
    ln -sf "${CONFIG_SHARED_PATH}/config/user-dirs.dirs" $HOME/.config/

    ln -sf "${CONFIG_SHARED_PATH}/config/git/"* $HOME/.config/git/
    ln -sf "${CONFIG_SHARED_PATH}/config/mpd/"* $HOME/.config/mpd/
    ln -sf "${CONFIG_SHARED_PATH}/config/ranger/"* $HOME/.config/ranger/
    ln -sf "${CONFIG_SHARED_PATH}/config/gtk-2.0/"* $HOME/.config/gtk-2.0/
    ln -sf "${CONFIG_SHARED_PATH}/config/containers/"* $HOME/.config/containers/

    # setup 'gnupg' related folder with the correct permissions and link configs
    mkdir -p $HOME/.gnupg
    chmod 700 $HOME/.gnupg
    ln -sf "${CONFIG_SHARED_PATH}/config/gnupg/"* $HOME/.gnupg/

    sudo cp "${CONFIG_SHARED_PATH}/config/udev/"* /etc/udev/rules.d/

    # link/copy scripts
    # --------------------------------------
    sudo ln -sf "${CONFIG_SHARED_PATH}/script/"*.sh /usr/local/bin/

    # links for root
    # --------------------------------------
    sudo mkdir -p /root/.shared/config/ranger
    sudo mkdir -p /root/.local/share/bash
    sudo ln -sf "${CONFIG_SHARED_PATH}/config/nvim" /root/.config/
    sudo ln -sf "${CONFIG_SHARED_PATH}/config/bash" /root/.config/
    sudo ln -sf "${CONFIG_SHARED_PATH}/config/.bashrc" /root/.bashrc
    sudo ln -sf "${CONFIG_SHARED_PATH}/config/ranger/"* /root/.config/ranger/

    # generate .profile file for root
    {
        printf "#!/bin/sh\n"; \
        printf "[ -f /root/.bashrc ] && . /root/.bashrc\n"; \
    } | sudo tee /root/.profile > /dev/null

    # generate new grub config
    # --------------------------------------
    sudo cp "${CONFIG_SHARED_PATH}/config/grub/grub" /etc/default/
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

file_setup_wayland() {
    # link/copy configs
    # --------------------------------------
    ln -sf "${CONFIG_WAYLAND_PATH}/config/mako" $HOME/.config/
    ln -sf "${CONFIG_WAYLAND_PATH}/config/swaylock" $HOME/.config/

    # create required directory to link configs
    mkdir -p "$HOME/.config/sway"

    ln -sf "${CONFIG_WAYLAND_PATH}/config/sway/config" $HOME/.config/sway/config
    ln -sf "${CONFIG_WAYLAND_PATH}/config/sway/config.d/dual_output.conf" \
        $HOME/.config/sway/output.conf

    # link/copy scripts
    # --------------------------------------
    sudo ln -sf "${CONFIG_WAYLAND_PATH}/script/"*.sh /usr/local/bin/
}

file_setup_x11() {
    # link/copy configs
    # --------------------------------------
    ln -sf "${CONFIG_X11_PATH}/config/X11" $HOME/.config/
    ln -sf "${CONFIG_X11_PATH}/config/awesome" $HOME/.config/

    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo cp "${CONFIG_X11_PATH}/config/xorg.conf.d/"* /etc/X11/xorg.conf.d/
}

package_installation_shared() {
    # always install archlinux-keyring to get updated database (needed after fresh install)
    sudo pacman -S --noconfirm archlinux-keyring

    # define packages for installation
    # --------------------------------------
    local packages=""

    # base
    packages="${packages} pacman-contrib openssh wget bash-completion ntfs-3g libnotify rsync"
    # base extras
    packages="${packages} unzip zip pipewire pipewire-pulse pulsemixer udiskie"

    # Ryzen / AMD GPU related
    packages="${packages} amd-ucode xf86-video-amdgpu amdvlk libva-mesa-driver mesa-vdpau"

    # Intel / Nvidia GPU related
    # packages="${packages} intel-ucode xf86-video-intel xf86-video-nouveau"

    # device driver:
    # Wacom graphic tablet -> xf86-input-wacom
    # Notebook touchpad -> xf86-input-synaptics

    # llvm
    packages="${packages} llvm clang lld lldb"
    # development
    packages="${packages} git cmake cppcheck doxygen graphviz qtcreator clazy gdb tk"
    # other development related programs which can be useful:
    # strace | valgrind | wireshark-qt | meld | ninja | meson

    # container
    # for more flexibility to build OCI container images use `buildah`
    # https://github.com/containers/buildah
    packages="${packages} podman crun"

    # music
    packages="${packages} mpd mpc"

    # cmdl
    packages="${packages} alacritty tmux ranger tig htop"
    packages="${packages} fzf ripgrep fd exa jq codespell"

    # style
    packages="${packages} qt5ct kvantum-qt5 papirus-icon-theme"
    # fonts
    packages="${packages} ttf-lato adobe-source-code-pro-fonts adobe-source-han-sans-jp-fonts"
    packages="${packages} noto-fonts noto-fonts-cjk noto-fonts-emoji"

    # graphics
    packages="${packages} krita krita-plugin-gmic inkscape scour python-lxml python-numpy"

    # browser
    packages="${packages} firefox hunspell-en_US"

    # gstreamer related (needed for video conferencing system)
    packages="${packages} gst-plugins-bad gst-plugins-good gst-plugins-ugly gst-plugins-bad-libs"

    # other
    packages="${packages} transmission-qt mpv imv mupdf android-file-transfer"

    # install packages
    # --------------------------------------
    sudo pacman -S --needed --noconfirm ${packages}

    # configuration for installed packages
    # --------------------------------------
    # create ramdisk just to be save that the microcodes are used
    sudo mkinitcpio -p linux

    # use rootless podman
    sudo touch /etc/subuid # file needs to exist before 'usermod' call
    sudo touch /etc/subgid # file needs to exist before 'usermod' call
    sudo usermod --add-subuids 165536-231072 --add-subgids 165536-231072 $(whoami)
    podman system migrate

    # create symlinks for custom QtCreator style/theme
    sudo ln -sf "${CONFIG_SHARED_PATH}/config/qtcreator/styles/"* /usr/share/qtcreator/styles/
    sudo ln -sf "${CONFIG_SHARED_PATH}/config/qtcreator/themes/"* /usr/share/qtcreator/themes/
    sudo ln -sf "${CONFIG_SHARED_PATH}/config/qtcreator/schemes/"* /usr/share/qtcreator/schemes/
}

package_installation_wayland() {
    # define packages for installation
    # --------------------------------------
    local packages=""

    # wayland compositor
    packages="${packages} wlroots sway swaybg swaylock xdg-desktop-portal-wlr xorg-xwayland"
    # wayland only
    packages="${packages} mako grim slurp wl-clipboard wf-recorder"

    # install packages
    # --------------------------------------
    sudo pacman -S --needed --noconfirm ${packages}
}

package_installation_x11() {
    # define packages for installation
    # --------------------------------------
    local packages=""

    # xorg
    packages="${packages} xorg-server xorg-server-devel xorg-server-xephyr xorg-xrdb xorg-xsetroot"
    packages="${packages} xorg-setxkbmap xorg-xset xorg-xinit xorg-xrandr xorg-xinput"
    packages="${packages} xorg-xhost xorg-xmodmap xorg-xprop"

    # xcb
    packages="${packages} libxcb xcb-util xcb-util-cursor xcb-util-image xcb-util-keysyms"
    packages="${packages} xcb-util-renderutil xcb-util-wm xcb-util-xrm"

    # other
    packages="${packages} awesome xclip nitrogen xsecurelock"

    # install packages
    # --------------------------------------
    sudo pacman -S --needed --noconfirm ${packages}
}

external_packages_shared() {
    mkdir -p /tmp/external_packages
    cd /tmp/external_packages || exit

    export CC=/usr/bin/clang
    export CXX=/usr/bin/clang++

    # define character at which a string should be split
    local IFS=','

    # iterate over custom packages
    # --------------------------------------
    local external_packages="neovim,sumneko_lua_lsp,shellcheck,pop-gtk-theme,iwyu,md-toc"

    for package in $external_packages; do
        cp -r "${CONFIG_SHARED_PATH}/pkgbuild/${package}" "./${package}"
        cd "./${package}" || return
        makepkg -sric --noconfirm || exit
        cd ../ || return
    done

    cd $HOME || return
    rm -rdf /tmp/external_packages
}

main "$@"
