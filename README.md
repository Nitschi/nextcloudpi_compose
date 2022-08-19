# Nextcloudpi Compose

Aims to provide everything needed to easily spin up a nextcloud instance in minutes using nextcloudpi docker

## Prerequisites

Linux PC with Ubuntu/Debian/Raspian

Works great on Raspberry Pi 4

### Setup Raspberry Pi

See [Setting up your Raspberry Pi](https://projects.raspberrypi.org/en/projects/raspberry-pi-setting-up)

### Install docker and docker-compose

See [Geek's Circuit: Install Docker on Raspberry Pi](https://geekscircuit.com/how-to-install-docker-and-docker-compose-on-raspberry-pi/)

### Mount your data and backup disks

See [The Pi Hut: Mount external drive on Raspberry Pi](https://thepihut.com/blogs/raspberry-pi-tutorials/how-to-mount-an-external-hard-drive-on-the-raspberry-pi-raspian)

You can base your fstab on example_fstab in this repo

### Setup unattended-upgrades (Optional)
See [cyberciti.biz: How to setup automatic updates](https://www.cyberciti.biz/faq/how-to-set-up-automatic-updates-for-ubuntu-linux-18-04/)

### Install Borg Backup

`sudo apt update && sudo apt install borgbackup`

## Config

- Fill in your infos in the .env file

- Fill in your setup info into the borg_backup_settings.bash

- Make borg_backup_settings.bash owned by root, so no other user can read the password:
    - `sudo chown root:root borg_backup_settings.bash`
    - `sudo chmod og-rwx borg_backup_settings.bash`

- Add entries to root's crontab based on example_crontab:
    - `sudo crontab -e`

## Start Nextcloud container
`docker pull ownyourbits/nextcloudpi:latest`

`docker-compose up -d`
