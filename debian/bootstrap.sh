#!/bin/bash

set -x

unset UCF_FORCE_CONFFOLD
export DEBIAN_FRONTEND=noninteractive
export UCF_FORCE_CONFFNEW=YES

ucf --purge /boot/grub/menu.lst
sudo dpkg-reconfigure debconf -f noninteractive -p critical

APT_GET="sudo apt-get"
APT_GET_INSTALL="$APT_GET -qy --no-install-recommends install"

# configure sudo
# omab ALL=(ALL) NOPASSWD:ALL

# update to testing
# echo "deb http://mirrors.kernel.org/debian/ testing main contrib non-free" > /etc/apt/sources.list
# $APT_GET update
# $APT_GET upgrade
# $APT_GET dist-upgrade

# REBOOT to boot into the new kernel

# update to sid
grep -e sid /etc/apt/sources.list || (
    echo "deb http://mirrors.kernel.org/debian/ sid main contrib non-free" | sudo tee /etc/apt/sources.list
    $APT_GET update
    $APT_GET -qy upgrade
    $APT_GET -qy dist-upgrade
    # REBOOT to boot into the new kernel
)

# restore backup

$APT_GET -qy autoremove gdm3
$APT_GET -qy autoremove --purge 'gnome*'

$APT_GET_INSTALL ack-grep arandr aspell-en aspell-es autojump curl emacs25 \
                 evince feh geeqie git gparted htop i3 i3lock i3blocks ipython \
                 mpv nfs-common nfs-kernel-server nodejs npm pry redshift ruby \
                 rxvt-unicode scrot slim suckless-tools unp vagrant vim-gtk \
                 virtualenv virtualenvwrapper weechat weechat-plugins \
                 weechat-scripts zfs-dkms zfsutils-linux zsh silversearcher-ag \
                 rofi fonts-font-awesome dunst apt-transport-https \
                 ca-certificates software-properties-common imagemagick

# $APT_GET_INSTALL awesome awesome-extra sakura

sudo ln -s /usr/bin/nodejs /usr/local/bin/node

# Fetch dotfiles
curl -s https://raw.githubusercontent.com/omab/dotfiles/master/.bin/dotfiles-bootstrap | bash -

# Configure brightness
[[ -d /usr/share/X11/xorg.conf.d ]] && (
cat <<EOF | sudo tee /usr/share/X11/xorg.conf.d/20-intel.conf
Section "Device"
  Identifier  "card0"
  Driver      "intel"
  Option      "Backlight"  "intel_backlight"
  BusID       "PCI:0:2:0"
EndSection
EOF
)

# Configure screen lock on suspend
[[ -d /etc/systemd/system ]] && (
cat <<EOF | sudo tee /etc/systemd/system/i3lock.service
[Unit]
Description=i3lock
Before=sleep.target

[Service]
User=omab
Type=forking
Environment=DISPLAY=:0
ExecStart=/home/omab/.bin/i3-lock-fancy.sh

[Install]
WantedBy=sleep.target
EOF
)

# Configure suspend on lid close and other options
[[ -f /etc/systemd/logind.conf ]] && (
  sed -i 's/#KillUserProcesses=.*/KillUserProcesses=no/' /etc/systemd/logind.conf;
  sed -i 's/#HandleLidSwitch=.*/HandleLidSwitch=suspend/' /etc/systemd/logind.conf;
  sed -i 's/#HandleLidSwitchDocked=.*/HandleLidSwitchDocked=suspend/' /etc/systemd/logind.conf;
  sed -i 's/#LidSwitchIgnoreInhibited=.*/LidSwitchIgnoreInhibited=no/' /etc/systemd/logind.conf
)

# install crontab rules

for name in "org psa work default"; do
    (crontab -l; echo "@reboot emacs --daemon=$name") | crontab -
done

# install chrome / virtualbox / docker

echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget -q https://dl.google.com/linux/linux_signing_key.pub -O- | sudo apt-key add -

echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

sudo add-apt-repository "deb https://apt.dockerproject.org/repo/ debian-$(lsb_release -cs) main"
wget -q https://apt.dockerproject.org/gpg -O- | sudo apt-key add -

$APT_GET update
$APT_GET_INSTALL --allow-unauthenticated google-chrome-stable virtualbox virtualbox-ext-pack docker-engine
sudo ln -sf /usr/bin/google-chrome /usr/local/bin/chrome

# gems / pip / etc packages

sudo gem install rubocop
sudo npm install -g eslint babel-eslint eslint-plugin-react
$APT_GET_INSTALL python-flake8 pylint pylint3
