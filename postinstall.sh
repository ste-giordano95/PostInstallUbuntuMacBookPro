#!/bin/bash

printf "/////////////////////////////////////////////////////\n";
printf "//////////SCRIPT POST INSTALL UBUNTU ON MBP////////// \n";
printf "////////////////////////BY STEWIET/////////////////// \n";
printf "/////////////////////////////////////////////////////\n";

sudo apt-get update

# Crea una cartella temporanea
TEMP_DIR=$(mktemp -d)
echo "Directory temporanea creata: $TEMP_DIR"

# Naviga nella cartella temporanea
cd "$TEMP_DIR"

printf "Installing dependencies\n";
sudo apt-get install -y git
sudo apt-get install -y unzip
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

# Scarica il file utilizzando wget con content-disposition
wget --content-disposition https://cloud.mogbox.net/index.php/s/r8av1dUADSEQvXW/download

# Estrai il file ZIP nella cartella temporanea
unzip facetimehd-dkms_0.1_all-20221111.zip

# Installa il pacchetto .deb
sudo dpkg -i facetimehd-dkms_0.1_all-20221111.deb

# Risolve le dipendenze mancanti
sudo apt-get install -f

# Verifica l'installazione
dpkg -l | grep facetimehd

printf "Install mbpfan\n";
sudo apt-get install -y mbpfan
printf "done\n\n";

printf "Run on start\n";
git clone https://github.com/linux-on-mac/mbpfan.git
cd mbpfan
sudo cp mbpfan.upstart /etc/init/mbpfan.conf

sudo mbpfan
printf "done\n\n";

printf "Cleaning...\n";

# Naviga fuori dalla cartella temporanea
cd ~

# Rimuove la cartella temporanea e tutto il suo contenuto
rm -rf "$TEMP_DIR"
printf "done\n";

printf "Please Reboot system.\n";
printf "Script Ended\n";
