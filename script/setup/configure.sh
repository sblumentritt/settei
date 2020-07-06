#!/bin/sh

# global variable
CONFIG_BASE_PATH="$HOME/development/unspecified/settei"
CARGO_HOME="$HOME/.local/share/cargo"

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
    wanted_folder="development,documents,downloads,music,pictures,videos,.ssh,.cache"
    for folder in $wanted_folder; do
        mkdir -p "$HOME/$folder"
    done

    wanted_folder="ranger,mpd,git,sway,gtk-2.0"
    for folder in $wanted_folder; do
        mkdir -p "$HOME/.config/$folder"
    done

    if [ -f /etc/profile.d/work.sh ]; then
        mkdir -p $HOME/development/work
    else
        mkdir -p $HOME/downloads/torrents
    fi

    # required to not pollute the home dir
    mkdir -p "$HOME/.local/share/tig"
    mkdir -p "$HOME/.local/share/bash"
    mkdir -p "$CARGO_HOME"
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
    ln -sf "${CONFIG_BASE_PATH}/config/qt5ct" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/Kvantum" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/gtk-3.0" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/swaylock" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/alacritty" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/fontconfig" $HOME/.config/
    ln -sf "${CONFIG_BASE_PATH}/config/user-dirs.dirs" $HOME/.config/

    ln -sf "${CONFIG_BASE_PATH}/config/mpd/"* $HOME/.config/mpd/
    ln -sf "${CONFIG_BASE_PATH}/config/ranger/"* $HOME/.config/ranger/
    ln -sf "${CONFIG_BASE_PATH}/config/gtk-2.0/"* $HOME/.config/gtk-2.0/

    ln -sf "${CONFIG_BASE_PATH}/config/sway/config" $HOME/.config/sway/config
    if [ ! -f /etc/profile.d/work.sh ]; then
        ln -sf "${CONFIG_BASE_PATH}/config/sway/config.d/dual_output.conf" \
            $HOME/.config/sway/output.conf
    else
        ln -sf "${CONFIG_BASE_PATH}/config/sway/config.d/triple_output.conf" \
            $HOME/.config/sway/output.conf
    fi

    if [ -f /etc/profile.d/work.sh ]; then
        cp "${CONFIG_BASE_PATH}/config/git/config" $HOME/.config/git/config
        nvim $HOME/.config/git/config
    else
        ln -sf "${CONFIG_BASE_PATH}/config/git/config" $HOME/.config/git/config
    fi

    ln -sf "${CONFIG_BASE_PATH}/config/git/ignore" $HOME/.config/git/ignore
    ln -sf "${CONFIG_BASE_PATH}/config/cargo/config.toml" $CARGO_HOME/config

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

    if [ -f /etc/profile.d/work.sh ]; then
        # disable annoying pc speaker
        sudo sh -c 'printf "blacklist pcspkr\n" > /etc/modprobe.d/nobeep.conf'
    fi

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
    packages="${packages} unzip zip pulseaudio pulsemixer udiskie light"

    # graphic driver
    packages="${packages} xf86-video-intel xf86-video-nouveau"
    # device driver
    packages="${packages} xf86-input-wacom xf86-input-synaptics"

    # wayland compositor
    packages="${packages} wlroots sway swaybg swaylock xorg-server-xwayland"
    # wayland only
    packages="${packages} mako grim slurp wl-clipboard"

    # llvm
    packages="${packages} llvm clang lld lldb"
    # development
    packages="${packages} git rustup cmake"

    # music
    packages="${packages} mpd mpc"

    # cmdl
    packages="${packages} alacritty neovim yarn tmux ranger tig htop"
    packages="${packages} fzf ripgrep fd exa jq"

    # style
    packages="${packages} qt5ct kvantum-qt5 papirus-icon-theme"
    # fonts
    packages="${packages} ttf-lato adobe-source-code-pro-fonts adobe-source-han-sans-jp-fonts"

    # other
    packages="${packages} chromium transmission-qt mpv imv mupdf android-file-transfer"

    if [ -f /etc/profile.d/work.sh ]; then
        # work extras
        packages="${packages} xf86-video-amdgpu wireshark-qt nload socat"
        # work development
        packages="${packages} cppcheck doxygen graphviz"
        # work cross development
        packages="${packages} minicom cpio docker aarch64-linux-gnu-gcc"

        # old packages:
        # gdb strace valgrind nmap meld tftp-hpa tk
    fi

    # install packages
    # --------------------------------------
    sudo pacman -S --needed --noconfirm ${packages}

    # configuration for installed packages
    # --------------------------------------
    # define installation location for 'rustup'
    export RUSTUP_HOME="$HOME/.local/share/rustup"

    # set rustup profile to minimal (installs rustc/rust-std/cargo)
    rustup set profile minimal

    # set default rust toolchain (also downloads)
    rustup default stable

    # add development related rust components (also downloads)
    rustup component add rust-src rust-docs rustfmt clippy

    # check for updates e.g. if previously installed
    rustup update

    if [ -f /etc/profile.d/work.sh ]; then
        # add required groups to current user
        # --------------------------------------
        sudo gpasswd -a $USER uucp # for minicom
        sudo gpasswd -a $USER wireshark
        sudo gpasswd -a $USER docker

        # create configs
        # --------------------------------------
        sudo mkdir -p /etc/systemd/system/docker.service.d
        if [ ! -f /etc/systemd/system/docker.service.d/proxy.conf ]; then
            {
                printf "[Service]\n"; \
                printf "Environment=\"HTTP_PROXY=%s\"\n" "$HTTP_PROXY"; \
                printf "Environment=\"HTTPS_PROXY=%s\"\n" "$HTTP_PROXY"; \
            } | sudo tee -a /etc/systemd/system/docker.service.d/proxy.conf > /dev/null
        fi

        # enable/start services
        # --------------------------------------
        sudo systemctl enable docker.service
        sudo systemctl start docker.service
    fi
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
    local external_packages="swaystatus,shellcheck,pop-gtk-theme"

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
