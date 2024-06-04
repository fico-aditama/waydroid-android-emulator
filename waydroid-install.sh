#!/bin/bash

# Function to install Waydroid
install_waydroid() {
    echo "Installing Waydroid..."
    sudo apt update
    sudo apt install curl ca-certificates -y
    curl https://repo.waydro.id | sudo bash
    curl https://repo.waydro.id | sudo bash -s jammy
    sudo apt install -y waydroid
    waydroid prop set persist.waydroid.width 506
    waydroid prop set persist.waydroid.height 1000
    sudo ufw allow 53
    sudo ufw allow 67
    sudo ufw default allow FORWARD
    sudo waydroid init
    echo "Waydroid installation complete."

    echo "Installing Weston..."
    sudo apt install weston -y
    export WAYLAND_DISPLAY=wayland-0
    export XDG_SESSION_TYPE=wayland
    weston --backend=x11-backend.so
    echo "Weston installation complete."

    # sudo mount --bind /home/fadi/Downloads/code/android-waydroid/waydroid-github/applications/  ~/.local/share/waydroid/data/media/0/}

# Function to uninstall Waydroid
uninstall_waydroid() {
    echo "Uninstalling Waydroid..."
    sudo systemctl stop waydroid-container.service
    sudo systemctl stop waydroid-session.service
    sudo waydroid container stop
    waydroid session stop
    sudo apt remove waydroid -y
    sudo apt autoremove -y
    sudo rm -rf /etc/waydroid/
    sudo waydroid container stop
    sudo rm -rf /var/lib/waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid
    sudo rm /etc/apt/sources.list.d/waydroid.list /usr/share/keyrings/waydroid.gpg
    echo "Waydroid uninstallation complete."
}

# Function to install Waydroid script dependencies
install_waydroid_script() {
    echo "Installing Waydroid script and dependencies..."
    git clone https://github.com/casualsnek/waydroid_script
    cd waydroid_script
    python3 -m venv venv
    venv/bin/pip install -r requirements.txt
    sudo venv/bin/python3 -m pip install inquirerpy tqdm pyclip
    for pkg in gapps magisk libndk libhoudini nodataperm microg mitm google widevine hidestatusbar certified; do
        sudo venv/bin/python3 main.py install $pkg
    done
    sudo venv/bin/python3 main.py hack nodataperm
    echo "Waydroid script and dependencies installation complete."
}

# Function to install additional dependencies
install_ubuntu_dependencies() {
    echo "Installing additional dependencies..."
    sudo apt update
    sudo apt install -y accountsservice-ubuntu-schemas activity-log-manager bridge-utils caribou eom eom-common ffmpegthumbnailer \
    five-or-more folks-common fonts-cantarell fonts-symbola four-in-a-row gir1.2-caribou-1.0 gir1.2-champlain-0.12 \
    gir1.2-clutter-1.0 gir1.2-cogl-1.0 gir1.2-coglpango-1.0 gir1.2-eom-1.0 gir1.2-geocodeglib-1.0 gir1.2-gfbgraph-0.2 \
    gir1.2-grilo-0.3 gir1.2-gst-plugins-bad-1.0 gir1.2-gtkchamplain-0.12 gir1.2-gtkclutter-1.0 gir1.2-mediaart-2.0 \
    gir1.2-pluma-1.0 gir1.2-rest-0.7 gnome-2048 gnome-chess gnome-clocks gnome-color-manager gnome-contacts gnome-games \
    gnome-klotski gnome-maps gnome-music gnome-nibbles gnome-online-miners gnome-robots gnome-shell-extensions gnome-sound-recorder \
    gnome-taquin gnome-tetravex gnome-tweaks gnome-weather hitori hoichess iagno libcaribou-common libcaribou0 libcpufreq0 \
    libffmpegthumbnailer4v5 libfolks-eds26 libfolks26 libgbinder libgeonames-common libgeonames0 libgfbgraph-0.2-0 libglibutil \
    libgsf-bin libgtksourceview-3.0-1 libgtksourceview-3.0-common libgucharmap-2-90-7 liblxc-common liblxc1 libmate-slab0 \
    libmate-window-settings1 libmatedict6 libmatemixer-common libmatemixer0 libpam-cgfs libproxy1-plugin-webkit libtimezonemap-data \
    libtimezonemap1 libunity-control-center1 libzapojit-0.0-0 lightsoff lxc lxc-utils lxcfs mate-applet-brisk-menu mate-applets \
    mate-applets-common mate-backgrounds mate-calc mate-calc-common mate-control-center-common mate-media mate-media-common \
    mate-settings-daemon-common mate-utils mate-utils-common pluma pluma-common python3-gbinder python3-proton-vpn-session \
    quadrapassel swell-foop tali ubuntu-mate-icon-themes ubuntu-mate-themes uidmap x11-apps x11-session-utils xbitmaps xinit \
    xorg-docs-core yaru-theme-unity
    echo "Additional dependencies installation complete."
}

# Function to install demo applications
install_apk_demo() {
    echo "Installing demo applications..."
    
    # Get the current working directory
    current_dir=$(pwd)
    
    # Define the paths to the APK files
    apk1="${current_dir}/applications/subway.apk"
    apk2="${current_dir}/applications/subway-surfers-3-29-1.apk"

    # Check if the APK files exist and install them
    if [[ -f "$apk1" ]]; then
        waydroid app install "$apk1"
    else
        echo "APK file not found: $apk1"
    fi
    
    if [[ -f "$apk2" ]]; then
        waydroid app install "$apk2"
    else
        echo "APK file not found: $apk2"
    fi
    
    echo "Demo applications installation complete."
}
# Main menu
while true; do
    echo "Choose an option:"
    echo "1) Install Waydroid"
    echo "2) Uninstall Waydroid"
    echo "3) Install Waydroid script and dependencies"
    echo "4) Install demo application"
    echo "5) Install additional dependencies"
    echo "6) Exit"
    read -rp "Enter choice [1-6]: " choice
    case $choice in
        1) install_waydroid ;;
        2) uninstall_waydroid ;;
        3) install_waydroid_script ;;
        4) install_apk_demo ;;
        5) install_ubuntu_dependencies ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice, please try again." ;;
    esac
done
