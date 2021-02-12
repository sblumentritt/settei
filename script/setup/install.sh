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

main() {
    # script should be run as root
    if [ "$(id -u)" -ne 0 ]; then
        printf "Please run as root!\n" 1>&2
        exit 1
    fi

    # show list of block devices for easier selection
    lsblk -a -o NAME,SIZE,MOUNTPOINT

    printf "\nOn which drive do you want to install the system? "
    read -r drive_path

    printf "Which hostname do you want to use? "
    read -r custom_hostname

    printf "Which custom group should be created? "
    read -r custom_group

    printf "Which custom user should be created? "
    read -r custom_user

    if [ -z "${drive_path}" ]; then
        printf "\nDrive path needs to be set and can not be empty!\n" 1>&2
        exit 1
    elif [ -z "${custom_hostname}" ]; then
        printf "\nHostname needs to be set and can not be empty!\n" 1>&2
        exit 1
    elif [ -z "${custom_group}" ]; then
        printf "\nCustom group needs to be set and can not be empty!\n" 1>&2
        exit 1
    elif [ -z "${custom_user}" ]; then
        printf "\nCustom user needs to be set and can not be empty!\n" 1>&2
        exit 1
    else
        local mount_point="/mnt"

        local color='\033[33m' # yellow/orange
        local color_reset='\033[0m'

        printf "\n${color}[ Start partitioning ]${color_reset}\n"
        partition ${drive_path}

        printf "\n${color}[ Start formatting and mounting ]${color_reset}\n"
        format_and_mount ${drive_path} ${mount_point} ${custom_hostname}

        printf "\n${color}[ Start installing base packages ]${color_reset}\n"
        install ${mount_point}

        printf "\n${color}[ Start configuring the system ]${color_reset}\n"
        configure ${mount_point} ${custom_hostname} ${custom_group} ${custom_user}

        printf "\n${color}[ Installation done! ]\n"
    fi
}

partition() {
    local drive_path=$1

    wipefs -a "${drive_path}"

    (
    printf "%s\n" "g" # create a new empty GPT partition table
    printf "%s\n" "n" # add a new partition
    printf "%s\n" "" # default partition number (1)
    printf "%s\n" "" # default first sector
    printf "%s\n" "+550M" # partition size for EFI (recommended size)
    printf "%s\n" "t" # change partition type
    printf "%s\n" "C12A7328-F81F-11D2-BA4B-00A0C93EC93B" # type: 'EFI'
    printf "%s\n" "n" # add a new partition
    printf "%s\n" "" # default partition number (2)
    printf "%s\n" "" # default first sector
    printf "%s\n" "+1G" # partition size for /boot
    printf "%s\n" "n" # add a new partition
    printf "%s\n" "" # default partition number (3)
    printf "%s\n" "" # default first sector
    printf "%s\n" "" # default last sector (remaining space)
    printf "%s\n" "w" # write changes
    ) | fdisk "${drive_path}"

    sleep 2s # TODO: why? Do we have to wait for the partitioning to take effect?
}

format_and_mount() {
    local drive_path=$1
    local mount_point=$2
    local custom_hostname=$3

    lsblk "${drive_path}"
    # as it is unpredictable how the drives are named (sdxY,mmcblkxpY,nvme0nxpY)
    # -> https://wiki.archlinux.org/index.php/Device_file
    # it is much safer to just ask the user for the partition paths
    printf "Please enter the 'efi' partition path: "
    read -r efi_partition

    printf "Please enter the 'boot' partition path: "
    read -r boot_partition

    printf "Please enter the 'root' partition path: "
    read -r root_partition

    # format partitions
    mkfs.fat -F32 -n "efi" "${efi_partition}"
    mkfs.btrfs -f -L "boot" "${boot_partition}"
    mkfs.btrfs -f -L "arch" "${root_partition}"

    # create subvolumes
    mount -t btrfs ${root_partition} ${mount_point}
    (
        cd "${mount_point}" || exit

        btrfs subvolume create "${custom_hostname}"
        btrfs subvolume create "${custom_hostname}/root"
        btrfs subvolume create "${custom_hostname}/home"
        btrfs subvolume create "${custom_hostname}/var"
        btrfs subvolume create "snapshots"
    )

    umount -R ${mount_point}

    # mount subvolumes on correct positions with the correct options
    local common_mount_options="noatime,space_cache,commit=120"

    mount -o "${common_mount_options},compress=zstd,subvol=${custom_hostname}/root" \
        ${root_partition} ${mount_point}

    # define variables to create folders needed for the mount
    local IFS=','
    local wanted_folder="efi,boot,home,var,snap"

    for folder in $wanted_folder; do
        mkdir -p "${mount_point}/${folder}"
    done

    mount ${efi_partition} ${mount_point}/efi
    mount -o "${common_mount_options},compress=lzo" ${boot_partition} ${mount_point}/boot

    mount -o "${common_mount_options},compress=zstd,subvol=${custom_hostname}/home" \
        ${root_partition} ${mount_point}/home

    mount -o "${common_mount_options},compress=zstd,subvol=${custom_hostname}/var" \
        ${root_partition} ${mount_point}/var

    mount -o "${common_mount_options},compress=zstd,subvol=snapshots" \
        ${root_partition} ${mount_point}/snap
}

install() {
    # use 'reflector' for the best mirror before package installation
    pacman -Sy --noconfirm pacman-mirrorlist reflector
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old

    reflector --country "de,jp,ee,se,fi,no,fr" --sort country \
        --latest 55 --protocol "https,ftp" --sort rate \
        --verbose --save /etc/pacman.d/mirrorlist

    local packages=""

    # base
    packages="${packages} coreutils systemd systemd-sysvcompat bash"
    packages="${packages} linux linux-firmware mkinitcpio grub efibootmgr"

    # network
    packages="${packages} networkmanager iproute2 iputils"

    # filesystem utils
    packages="${packages} dosfstools e2fsprogs sysfsutils btrfs-progs"

    # compression
    packages="${packages} bzip2 gzip tar xz lzop"

    # devel
    packages="${packages} gcc gcc-libs perl autoconf automake binutils"
    packages="${packages} fakeroot libtool make patch pkgconf"

    # utils
    packages="${packages} file findutils gawk grep less pacman procps-ng"
    packages="${packages} sed usbutils pciutils util-linux which sudo"

    # misc
    packages="${packages} man-db man-pages openssh git nano"

    # install packages to mount point
    pacstrap -i $1 $packages
}

configure() {
    local mount_point=$1
    local custom_hostname=$2
    local custom_group=$3
    local custom_user=$4

    local color='\033[36m' # cyan
    local color_reset='\033[0m'
    local snapshot_name=$(date "+base_install_%Y%m%d_%s")

    # generate config suitable for /etc/fstab
    genfstab -p -U ${mount_point} >> ${mount_point}/etc/fstab

    # generate script to configure the system
    cat > ${mount_point}/rootfs_configure.sh << EOF
#!/bin/sh

main() {
    localization
    date_time
    network
    user
    misc
}

localization() {
    printf "${color}-- enable locales in /etc/locale.gen${color_reset}\\n"
    sed -i -E 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
    sed -i -E 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
    sed -i -E 's/#ja_JP.EUC-JP EUC-JP/ja_JP.EUC-JP EUC-JP/g' /etc/locale.gen
    sed -i -E 's/#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen

    printf "${color}-- define language in /etc/locale.conf${color_reset}\\n"
    printf "LANG=en_US.UTF-8\\n" > /etc/locale.conf

    printf "${color}-- define keymap in /etc/vconsole.conf${color_reset}\\n"
    printf "KEYMAP=us\\n" > /etc/vconsole.conf

    printf "${color}-- update locales${color_reset}\\n"
    locale-gen
}

date_time() {
    printf "${color}-- link zoneinfo to /etc/localtime${color_reset}\\n"
    ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

    printf "${color}-- update hardware clock${color_reset}\\n"
    hwclock -w
}

network() {
    printf "${color}-- write hostname into /etc/hostname${color_reset}\\n"
    printf "${custom_hostname}\\n" > /etc/hostname

    printf "${color}-- update /etc/hosts${color_reset}\\n"
    {
        printf "\\n# The following lines are desirable for IPv4 capable hosts\\n"; \
        printf "127.0.0.1   localhost\\n"; \
        printf "127.0.0.1   ${custom_hostname}.localdomain  ${custom_hostname}\\n"; \
        printf "\\n# The following lines are desirable for IPv6 capable hosts\\n"; \
        printf "::1             localhost ip6-localhost ip6-loopback\\n"; \
        printf "ff02::1         ip6-allnodes\\n"; \
        printf "ff02::2         ip6-allrouters\\n"; \
    } >> /etc/hosts

    printf "${color}-- enable network manager systemd service${color_reset}\\n"
    systemctl enable NetworkManager.service
}

user() {
    printf "${color}-- add new group '${custom_group}' ${color_reset}\\n"
    groupadd ${custom_group}

    printf "${color}-- add new user '${custom_user}' ${color_reset}\\n"
    useradd -m -g ${custom_group} -G wheel,users,audio,video,input -s /bin/bash ${custom_user}

    printf "${color}-- set password for root${color_reset}\\n"
    passwd

    printf "${color}-- set password for user '${custom_user}' ${color_reset}\\n"
    passwd ${custom_user}

    printf "${color}-- update /etc/sudoers${color_reset}\\n"
    {
        printf "%%${custom_group} ALL=(ALL) NOPASSWD: ALL\\n"; \
        printf "${custom_user} ALL=(ALL) NOPASSWD: ALL\\n"; \
        printf "Defaults env_keep += \\"http_proxy https_proxy ftp_proxy\\"\\n"; \
    } >> /etc/sudoers
}

misc() {
    printf "${color}-- enable options in /etc/pacman.conf${color_reset}\\n"
    sed -i -E 's/#Color/Color\\nILoveCandy/g' /etc/pacman.conf
    sed -i -E 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
    sed -i -E 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf

    printf "${color}-- enable MAKEFLAGS in /etc/makepkg.conf${color_reset}\\n"
    sed -i -E 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j"/g' /etc/makepkg.conf
    sed -i -E 's/DEBUG_CFLAGS="-g -fvar-tracking-assignments"/DEBUG_CFLAGS="-g"/g' /etc/makepkg.conf
    sed -i -E 's/DEBUG_CXXFLAGS="-g -fvar-tracking-assignments"/DEBUG_CXXFLAGS="-g"/g' /etc/makepkg.conf

    printf "${color}-- update /etc/mkinitcpio.conf and create ramdisk${color_reset}\\n"
    sed -i -E 's/fsck\\)/fsck btrfs\\)/g' /etc/mkinitcpio.conf
    mkinitcpio -p linux

    printf "${color}-- install grub and generate config${color_reset}\\n"
    grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=arch_grub --recheck
    grub-mkconfig -o /boot/grub/grub.cfg

    printf "${color}-- create btrfs snapshots from the current system${color_reset}\\n"
    mkdir -p /snap/root /snap/home
    btrfs subvolume snapshot -r / /snap/root/root_${snapshot_name}
    btrfs subvolume snapshot -r /home /snap/home/home_${snapshot_name}
}

main
EOF
    # run script in real system context
    chmod +x ${mount_point}/rootfs_configure.sh
    arch-chroot ${mount_point} /usr/bin/sh -c "/rootfs_configure.sh"

    rm ${mount_point}/rootfs_configure.sh
    umount -R ${mount_point}
}

main "$@"
