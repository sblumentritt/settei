#!/bin/sh

# global variable
CONFIG_BASE_PATH="$HOME/workspace/configs/settei"

main() {
    printf "\nSetup directories? [y/n] "
    read -r dir_flag

    if [ "${dir_flag}" = "y" ] || [ "${dir_flag}" = "Y" ]; then
        dir_setup
    fi

    printf "\nSetup files? [y/n] "
    read -r file_flag

    if [ "${file_flag}" = "y" ] || [ "${file_flag}" = "Y" ]; then
        file_setup
    fi

    printf "\nInstall packages (core/community/extra)? [y/n] "
    read -r package_flag

    if [ "${package_flag}" = "y" ] || [ "${package_flag}" = "Y" ]; then
        package_installation
    fi

    printf "\nExternal packages (AUR/git)? [y/n] "
    read -r external_flag

    if [ "${external_flag}" = "y" ] || [ "${external_flag}" = "Y" ]; then
        external_packages
    fi
}

dir_setup() {
    # define character at which a string should be split
    local IFS=','
    local wanted_folder=""

    # create directories
    wanted_folder="workspace,documents,downloads,music,pictures,videos,.ssh,.cache"
    for folder in $wanted_folder; do
        mkdir -p "$HOME/$folder"
    done

    mkdir -p $HOME/downloads/torrents

    wanted_folder="ranger,mpd,git,sway,gtk-2.0,containers"
    for folder in $wanted_folder; do
        mkdir -p "$HOME/.config/$folder"
    done

    # required to not pollute the home dir
    mkdir -p "$HOME/.local/share/tig"
    mkdir -p "$HOME/.local/share/bash"
}

file_setup() {
    # link/copy dotfiles
    # --------------------------------------
    ln -sf "${CONFIG_BASE_PATH}/config/.bashrc" $HOME/.bashrc
    ln -sf "${CONFIG_BASE_PATH}/config/.profile" $HOME/.profile

    # remove possible available .bash_profile which blocks .profile
    if [ -f $HOME/.bash_profile ]; then
        rm -rf $HOME/.bash_profile
    fi

    printf "command script import %s/config/lldb/settings.py\n" "${CONFIG_BASE_PATH}" \
        > $HOME/.lldbinit

    # link/copy configs
    # --------------------------------------
    ln -sf "${CONFIG_BASE_PATH}/config/mpv" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/imv" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/tig" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/nvim" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/tmux" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/mako" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/iwyu" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/qt5ct" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/Kvantum" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/gtk-3.0" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/swaylock" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/alacritty" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/fontconfig" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/user-dirs.dirs" $HOME/.config/

    ln -sf "${CONFIG_BASE_PATH}/config/git/"* $HOME/.config/git/
    ln -sf "${CONFIG_BASE_PATH}/config/mpd/"* $HOME/.config/mpd/
    ln -sf "${CONFIG_BASE_PATH}/config/ranger/"* $HOME/.config/ranger/
    ln -sf "${CONFIG_BASE_PATH}/config/gtk-2.0/"* $HOME/.config/gtk-2.0/
    ln -sf "${CONFIG_BASE_PATH}/config/containers/"* $HOME/.config/containers/

    ln -sf "${CONFIG_BASE_PATH}/config/sway/config" $HOME/.config/sway/config
    ln -sf "${CONFIG_BASE_PATH}/config/sway/config.d/dual_output.conf" \
        $HOME/.config/sway/output.conf

    # setup 'gnupg' related folder with the correct permissions and link configs
    mkdir -p $HOME/.gnupg
    chmod 700 $HOME/.gnupg
    ln -sf "${CONFIG_BASE_PATH}/config/gnupg/"* $HOME/.gnupg/

    sudo cp "${CONFIG_BASE_PATH}/config/udev/"* /etc/udev/rules.d/

    # link/copy scripts
    # --------------------------------------
    sudo ln -sf "${CONFIG_BASE_PATH}/script/"*.sh /usr/local/bin/

    # links for root
    # --------------------------------------
    sudo mkdir -p /root/.config/ranger
    sudo mkdir -p /root/.local/share/bash
    sudo ln -sf "${CONFIG_BASE_PATH}/config/nvim" /root/.config/
    sudo ln -sf "${CONFIG_BASE_PATH}/config/.bashrc" /root/.bashrc
    sudo ln -sf "${CONFIG_BASE_PATH}/config/ranger/"* /root/.config/ranger/

    # generate .profile file for root
    {
        printf "#!/bin/sh\n"; \
        printf "[ -f /root/.bashrc ] && . /root/.bashrc\n"; \
    } | sudo tee /root/.profile > /dev/null

    # generate new grub config
    # --------------------------------------
    sudo cp "${CONFIG_BASE_PATH}/config/grub/grub" /etc/default/
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

package_installation() {
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

    # wayland compositor
    packages="${packages} wlroots sway swaybg swaylock xdg-desktop-portal-wlr xorg-xwayland"
    # wayland only
    packages="${packages} mako grim slurp wl-clipboard"

    # llvm
    packages="${packages} llvm clang lld lldb"
    # development
    packages="${packages} git cmake cppcheck doxygen graphviz"

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
}

external_packages() {
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
        cp -r "${CONFIG_BASE_PATH}/pkgbuild/${package}" "./${package}"
        cd "./${package}" || return
        makepkg -sric --noconfirm || exit
        cd ../ || return
    done

    cd $HOME || return
    rm -rdf /tmp/external_packages
}

main "$@"
