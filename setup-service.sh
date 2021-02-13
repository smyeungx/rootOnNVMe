#!/bin/sh
# Setup the service to set the rootfs to point to the SSD
sudo cp data/setssdroot.service /etc/systemd/system
sudo cp data/reset-usb-root-devices.service /etc/systemd/system
sudo cp data/setssdroot.sh /sbin
sudo cp data/reset-usb-root-devices.sh /sbin
sudo chmod 777 /sbin/setssdroot.sh
sudo chmod 777 /sbin/reset-usb-root-devices.sh
systemctl daemon-reload
sudo systemctl enable setssdroot.service
sudo systemctl enable reset-usb-root-devices.service

# Copy these over to the SSD
sudo cp /etc/systemd/system/setssdroot.service /mnt/etc/systemd/system/setssdroot.service
sudo cp /sbin/setssdroot.sh /mnt/sbin/setssdroot.sh
sudo cp /etc/systemd/system/reset-usb-root-devices.service /mnt/etc/systemd/system/reset-usb-root-devices.service
sudo cp /sbin/reset-usb-root-devices.sh /mnt/sbin/reset-usb-root-devices.sh

# Create setssdroot.conf which tells the service script to set the rootfs to the SSD
# If you want to boot from SD again, remove the file /etc/setssdroot.conf from the SD card.
# touch creates an empty file
sudo touch /etc/setssdroot.conf
echo 'Service to set the rootfs to the SSD installed.'
echo 'Make sure that you have copied the rootfs to SSD.'
echo 'Reboot for changes to take effect.'

