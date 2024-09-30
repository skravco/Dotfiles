#!/bin/bash

# Comprehensive script to automate the installation of dwm, st, and dmenu with necessary configurations on Debian.

# Function to display a header
function print_header() {
    echo "=========================================="
    echo "$1"
    echo "=========================================="
}

# Step 1: Install dependencies
print_header "Installing necessary packages (Xorg, build tools, and libraries)..."
sudo apt update && sudo apt install -y git vim tmux xorg xinit build-essential libx11-dev libxinerama-dev sharutils suckless-tools libxft-dev

# Step 2: Create the suckless directory
print_header "Creating suckless directory in your home folder..."
mkdir -p ~/suckless && cd ~/suckless

# Step 3: Clone dwm, st, and dmenu repositories
print_header "Cloning dwm, st, and dmenu repositories..."
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu
git clone https://git.suckless.org/slstatus

# Step 4: Build and install dwm, st, and dmenu
print_header "Building and installing dwm..."
cd dwm
make && sudo make install

print_header "Building and installing st (simple terminal)..."
cd ../st
make && sudo make install

print_header "Building and installing dmenu..."
cd ../dmenu
make && sudo make install

print_header "Building and installing slstatus..."
cd ../slstatus
make && sudo make install

# Step 5: Create dwm.desktop for Display Manager (optional step, user can choose to skip)
echo "Would you like to create a dwm.desktop file for using a Display Manager? (y/n)"
read -r create_desktop_file

if [ "$create_desktop_file" == "y" ]; then
    print_header "Creating dwm.desktop for Display Manager..."
    sudo mkdir -p /usr/share/xsessions
    sudo touch /usr/share/xsessions/dwm.desktop
    sudo bash -c 'cat > /usr/share/xsessions/dwm.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Exec=dwm
Icon=dwm
Type=XSession
EOF'
    echo "dwm.desktop created in /usr/share/xsessions"
else
    echo "Skipping dwm.desktop creation."
fi

# Step 6: Add dwm to .xinitrc (to start dwm with startx)
print_header "Adding 'xrandr' to ~/.xinitrc..."
if [ -f ~/.xinitrc ]; then
    echo "xrandr --output Virtual1 --mode 1920x1080" >> ~/.xinitrc
else
    echo "xrandr --output Virtual1 --mode 1920x1080" > ~/.xinitrc
fi
echo "~/.xinitrc updated with 'xrandr'"


print_header "Adding 'slstatus' to ~/.xinitrc..."
if [ -f ~/.xinitrc ]; then
    echo "~/suckless/slstatus/slstatus &" >> ~/.xinitrc
else
    echo "~/suckless/slstatus/slstatus &" > ~/.xinitrc
fi
echo "~/.xinitrc updated with 'slstatus'"

print_header "Adding 'dwm' to ~/.xinitrc..."
if [ -f ~/.xinitrc ]; then
    echo "exec dwm" >> ~/.xinitrc
else
    echo "exec dwm" > ~/.xinitrc
fi
echo "~/.xinitrc updated with 'exec dwm'"


# Step 7: Auto start Xorg with startx on tty1 (add to .bashrc)
print_header "Configuring auto startx in ~/.bashrc..."
if ! grep -q "startx" ~/.bashrc; then
    echo 'if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then startx; fi' >> ~/.bashrc
    echo "~/.bashrc updated to auto start dwm on tty1"
else
    echo "startx auto-launch already present in ~/.bashrc"
fi

print_header "Installation complete!"
echo "Use 'startx' to launch dwm or log in via a Display Manager if you created the dwm.desktop file."

