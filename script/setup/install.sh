#!/bin/sh

# NOTE: before installing a new clean arch linux system
#       make sure to use the most recent ISO. Otherwise
#       keyring issues could occur.

# NOTE: if ethernet is not available for broadcom card
#       1. disconnect ethernet cable
#       2. run: modprobe -r tg3
#       3. run: modprobe broadcom
#       4. run: modprobe tg3
#       5. connect ethernet cable

main()
{
    # script should be run as root
    if [ "$(id -u)" -ne 0 ]; then
        printf "Please run as root!\n" 1>&2
        exit 1
    fi

    printf "\nOn which disk do you wanna install the system? "
    read -r _DISK_PATH

    printf "Which hostname do you wanna use? "
    read -r _HOST

    printf "Which custom group should be created? "
    read -r _CUSTOM_GROUP

    printf "Which custom user should be created? "
    read -r _CUSTOM_USER

    if [ -z "${_DISK_PATH}" ]; then
        printf "\nDisk path need to be set and can't be empty!\n" 1>&2
        exit 1
    elif [ -z "${_HOST}" ]; then
        printf "\nHostname need to be set and can't be empty!\n" 1>&2
        exit 1
    elif [ -z "${_CUSTOM_GROUP}" ]; then
        printf "\nCustom group need to be set and can't be empty!\n" 1>&2
        exit 1
    elif [ -z "${_CUSTOM_USER}" ]; then
        printf "\nCustom user need to be set and can't be empty!\n" 1>&2
        exit 1
    else
        local _MOUNT_POINT="/mnt"

        printf "\n[ Start partitioning ]\n"
        partition ${_DISK_PATH}

        printf "\n[ Start formating and mounting ]\n"
        format_and_mount ${_DISK_PATH} ${_MOUNT_POINT}

        printf "\n[ Start installing base packages ]\n"
        install ${_MOUNT_POINT}

        printf "\n[ Start configuring the system ]\n"
        configure ${_MOUNT_POINT} ${_DISK_PATH} ${_HOST} ${_CUSTOM_GROUP} ${_CUSTOM_USER}

        printf "\n[ Installation done! ]\n"
    fi
}

partition()
{
    (
    printf "%s\n" "g" # create a new empty GPT partition table
    printf "%s\n" "n" # add a new partition
    printf "%s\n" "" # default partition number (1)
    printf "%s\n" "" # default first sector
    printf "%s\n" "+1M" # partition size for bios boot
    printf "%s\n" "t" # change partition type
    printf "%s\n" "21686148-6449-6E6F-744E-656564454649" # type: 'BIOS boot'
    printf "%s\n" "n" # add a new partition
    printf "%s\n" "" # default partition number (2)
    printf "%s\n" "" # default first sector
    printf "%s\n" "+1G" # partition size for /boot
    printf "%s\n" "n" # add a new partition
    printf "%s\n" "" # default partition number (3)
    printf "%s\n" "" # default first sector
    printf "%s\n" "" # default last sector (remaining space)
    printf "%s\n" "w" # write changes
    ) | fdisk $1

    sleep 2s
}

format_and_mount()
{
    # define local variables
    local _BOOT_PARTITION="${1}2"
    local _ROOT_PARTITION="${1}3"

    local _MOUNT_POINT=$2
    local _MOUNT_OPTIONS="noatime,space_cache,commit=120"

    # format partitions
    mkfs.btrfs -f -L boot "${_BOOT_PARTITION}"
    mkfs.btrfs -f -L root "${_ROOT_PARTITION}"

    # create subvolumes
    mount -t btrfs ${_ROOT_PARTITION} ${_MOUNT_POINT}

    btrfs subvolume create "${_MOUNT_POINT}/__root"
    btrfs subvolume create "${_MOUNT_POINT}/__home"
    btrfs subvolume create "${_MOUNT_POINT}/__var"
    btrfs subvolume create "${_MOUNT_POINT}/__snap"

    umount -R ${_MOUNT_POINT}

    # mount subvolumes on correct positions
    mount -o "${_MOUNT_OPTIONS},compress=zstd,subvol=__root" ${_ROOT_PARTITION} ${_MOUNT_POINT}

    # define variables
    local IFS=','
    local wanted_folder="boot,home,snap,var"

    for folder in $wanted_folder; do
        mkdir -p "${_MOUNT_POINT}/$folder"
    done

    mount -o "${_MOUNT_OPTIONS},compress=lzo" ${_BOOT_PARTITION} ${_MOUNT_POINT}/boot

    mount -o "${_MOUNT_OPTIONS},compress=zstd,subvol=__home" ${_ROOT_PARTITION} ${_MOUNT_POINT}/home
    mount -o "${_MOUNT_OPTIONS},compress=zstd,subvol=__snap" ${_ROOT_PARTITION} ${_MOUNT_POINT}/snap
    mount -o "${_MOUNT_OPTIONS},compress=zstd,subvol=__var" ${_ROOT_PARTITION} ${_MOUNT_POINT}/var
}

install()
{
    local packages=""

    # base
    packages="${packages} linux linux-firmware intel-ucode grub"
    packages="${packages} coreutils systemd systemd-sysvcompat bash"

    # network
    packages="${packages} networkmanager iproute2 iputils"

    # filesytem utils
    packages="${packages} e2fsprogs sysfsutils btrfs-progs"

    # compression
    packages="${packages} bzip2 gzip tar xz"

    # devel
    packages="${packages} gcc gcc-libs perl autoconf automake binutils"
    packages="${packages} fakeroot libtool make patch pkgconf"

    # utils
    packages="${packages} file findutils gawk grep less pacman procps-ng"
    packages="${packages} sed usbutils util-linux which sudo"

    # misc
    packages="${packages} man-db man-pages neovim openssh git"

    # install packages to mount point
    pacstrap -i $1 $packages
}

configure()
{
    local _MOUNT_POINT=$1
    local _DISK_PATH=$2
    local _HOST=$3
    local _CUSTOM_GROUP=$4
    local _CUSTOM_USER=$5

    local _COLOR='\033[36m' # cyan
    local _COLOR_RESET='\033[0m'
    local _SNAPSHOT_NAME=$(date "+initial_setup_%Y_%m_%d")

    # generate config suitable for /etc/fstab
    genfstab -p -U ${_MOUNT_POINT} >> ${_MOUNT_POINT}/etc/fstab

    # generate script to configure the system
    cat > ${_MOUNT_POINT}/rootfs_configure.sh << EOF
#!/bin/sh

main()
{
    localization
    date_time
    network
    user
    misc
}

localization()
{
    printf "${_COLOR}-- enable locales in /etc/locale.gen${_COLOR_RESET}\\n"
    sed -i -E 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
    sed -i -E 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
    sed -i -E 's/#ja_JP.EUC-JP EUC-JP/ja_JP.EUC-JP EUC-JP/g' /etc/locale.gen
    sed -i -E 's/#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen

    printf "${_COLOR}-- define language in /etc/locale.conf${_COLOR_RESET}\\n"
    printf "LANG=en_US.UTF-8\\n" > /etc/locale.conf

    printf "${_COLOR}-- define keymap in /etc/vconsole.conf${_COLOR_RESET}\\n"
    printf "KEYMAP=us\\n" > /etc/vconsole.conf

    printf "${_COLOR}-- update locales${_COLOR_RESET}\\n"
    locale-gen
}

date_time()
{
    printf "${_COLOR}-- link zoneinfo to /etc/localtime${_COLOR_RESET}\\n"
    ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

    printf "${_COLOR}-- update hardware clock${_COLOR_RESET}\\n"
    hwclock -w
}

network()
{
    printf "${_COLOR}-- write hostname into /etc/hostname${_COLOR_RESET}\\n"
    printf "${_HOST}\\n" > /etc/hostname

    printf "${_COLOR}-- update /etc/hosts${_COLOR_RESET}\\n"
    {
        printf "\\n# The following lines are desirable for IPv4 capable hosts\\n"; \
        printf "127.0.0.1   localhost\\n"; \
        printf "127.0.0.1   ${_HOST}.localdomain  ${_HOST}\\n"; \
        printf "\\n# The following lines are desirable for IPv6 capable hosts\\n"; \
        printf "::1             localhost ip6-localhost ip6-loopback\\n"; \
        printf "ff02::1         ip6-allnodes\\n"; \
        printf "ff02::2         ip6-allrouters\\n"; \
    } >> /etc/hosts

    printf "${_COLOR}-- enable network manager systemd service${_COLOR_RESET}\\n"
    systemctl enable NetworkManager.service
}

user()
{
    printf "${_COLOR}-- add new group${_COLOR_RESET}\\n"
    groupadd ${_CUSTOM_GROUP}

    printf "${_COLOR}-- add new user${_COLOR_RESET}\\n"
    useradd -m -g ${_CUSTOM_GROUP} -G wheel,users,audio,video,input -s /bin/bash ${_CUSTOM_USER}

    printf "${_COLOR}-- set password for root${_COLOR_RESET}\\n"
    passwd

    printf "${_COLOR}-- set password for new user${_COLOR_RESET}\\n"
    passwd ${_CUSTOM_USER}

    printf "${_COLOR}-- update /etc/sudoers${_COLOR_RESET}\\n"
    {
        printf "%%${_CUSTOM_GROUP} ALL=(ALL) NOPASSWD: ALL\\n"; \
        printf "${_CUSTOM_USER} ALL=(ALL) NOPASSWD: ALL\\n"; \
        printf "Defaults env_keep += \\"http_proxy https_proxy ftp_proxy\\"\\n"; \
    } >> /etc/sudoers
}

misc()
{
    printf "${_COLOR}-- enable options in /etc/pacman.conf${_COLOR_RESET}\\n"
    sed -i -E 's/#Color/Color\\nILoveCandy/g' /etc/pacman.conf
    sed -i -E 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
    sed -i -E 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf

    printf "${_COLOR}-- enable MAKEFLAGS in /etc/makepkg.conf${_COLOR_RESET}\\n"
    sed -i -E 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j8"/g' /etc/makepkg.conf
    sed -i -E 's/DEBUG_CFLAGS="-g -fvar-tracking-assignments"/DEBUG_CFLAGS="-g"/g' /etc/makepkg.conf
    sed -i -E 's/DEBUG_CXXFLAGS="-g -fvar-tracking-assignments"/DEBUG_CXXFLAGS="-g"/g' /etc/makepkg.conf

    printf "${_COLOR}-- update /etc/mkinitcpio.conf and create ramdisk${_COLOR_RESET}\\n"
    sed -i -E 's/fsck\\)/fsck btrfs\\)/g' /etc/mkinitcpio.conf
    mkinitcpio -p linux

    printf "${_COLOR}-- install grub and generate config${_COLOR_RESET}\\n"
    grub-install ${_DISK_PATH}
    grub-mkconfig -o /boot/grub/grub.cfg

    printf "${_COLOR}-- create btrfs snapshots${_COLOR_RESET}\\n"
    btrfs subvolume snapshot -r / /snap/__root_${_SNAPSHOT_NAME}
    btrfs subvolume snapshot -r /home /snap/__home_${_SNAPSHOT_NAME}
}

main
EOF
    # run script in real system context
    chmod +x ${_MOUNT_POINT}/rootfs_configure.sh
    arch-chroot ${_MOUNT_POINT} /usr/bin/sh -c "/rootfs_configure.sh"

    rm ${_MOUNT_POINT}/rootfs_configure.sh
    umount -R ${_MOUNT_POINT}
}

main "$@"
