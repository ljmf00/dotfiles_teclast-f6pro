#!/usr/bin/env bash

# Greetings
echo -e "\e[95m-->\e[0m \e[1mWelcome to Teclast F6 Pro specific dotfiles\e[0m"

# Check for root permissions
if [ `id -u` -ne 0 ]; then
    echo -e "\e[91m==>\e[0m \e[1mThis script must be run as root\e[0m" 1>&2
    exit 1
fi

# Check for git
if ! [ -x "$(command -v git)" ]; then
    echo -e "\e[91m==>\e[0m \e[1mNo git installed\e[0m" 1>&2
    exit 1
fi

echo -e "\e[92m-->\e[0m \e[1mPatching rts5139...\e[0m"
git clone https://gitlab.com/aurorafossorg/utils/rts5139.git

pushd rts5139
make
make install
FILE='/etc/modprobe.d/blacklist.conf'
LINE='blacklist rtsx_usb_sdmmc'
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
LINE='blacklist rtsx_usb_ms'
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
LINE='blacklist rtsx_usb'
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
depmod -a
mkinitcpio -p linux
popd
