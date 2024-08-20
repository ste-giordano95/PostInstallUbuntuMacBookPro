#!/bin/bash

printf "/////////////////////////////////////////////////////\n";
printf "//////////SCRIPT POST INSTALL UBUNTU ON MBP////////// \n";
printf "////////////////////////BY STEWIET/////////////////// \n";
printf "/////////////////////////////////////////////////////\n";

mkdir PostInstallFile
cd PostInstallFile
printf "Installing dependencies\n";
sudo apt install git
printf "done\n";

git clone https://github.com/patjak/bcwc_pcie.git
cd bcwc_pcie/firmware
git clone https://github.com/patjak/facetimehd-firmware.git
cd facetimehd-firmware

printf "Installing dependencies\n";
sudo apt install xz-utils curl cpio make
sudo apt-get install linux-headers-generic git kmod libssl-dev checkinstall
printf "done\n"

printf "Installing or reinstall gcc-12\n";
sudo apt install --reinstall gcc-12
printf "done\n";

printf "Compiling firmware\n";
make
printf "done\n\n";

printf "Installing firmware\n";
sudo make install
printf "done\n\n";

cd ..
cd ..

printf "Compiling driver\n";
make
printf "done\n\n";

printf "Installing driver\n";
sudo make install
printf "done\n\n";

printf "Running depmod\n";
sudo depmod
printf "done\n\n";

printf "modprobe remove bdc_pci (if it exists)\n";
sudo modprobe --remove --quiet bdc_pci
printf "done\n\n";

printf "Loading driver\n";
sudo modprobe facetimehd
printf "done\n\n";

cd ..

printf "Install mbpfan\n";
sudo apt-get install mbpfan
printf "done\n\n";

printf "Run on start\n";
git clone https://github.com/linux-on-mac/mbpfan.git
cd mbpfan
sudo cp mbpfan.upstart /etc/init/mbpfan.conf

cd ..

sudo mbpfan
printf "done\n\n";

printf "Cleaning...\n";
sudo rm -r PostInstallFile
printf "done\n";
printf "Please Reboot system.\n";
printf "Script Ended\n";
