#!/bin/bash

# I have already generated a key pair for all my ssh needs, you can generate one too by using putty, ssh-generate etc.
# Prerequisitie: You need to copy your id_rsa and id_rsa.pub to termux at ~/.ssh/ from -> (bitwarden in my case) 
# You can use material file and navigate to /data/data/com.termux/files/home/.ssh and paste the keys there. 

# Updating the repositories
apt update && apt upgrade

# saying yes to all conflicts (install the package maintainer's version)
pkg install openssh tsu git gnupg iproute2 busybox termux-services

# Storage Access
termux-setup-storage

# Obsidian Specific
mkdir -p /sdcard/Obsidian/

# setting up ftp and ssh
sv-enable ftpd # it will run on port 8021, sv status, sv up, sv down are few cmds to note.
sshd # it will run on port 8022
passwd # simple but secure password which has to be used on ssh (recommended to use key pair)

# # generating gpg keys
# gpg --full-generate-key # RSA-and-RSA, 4096, 0, ## Email: Github private email from setting should be used to generate gpg, 
# gpg --list-secret-keys --keyid-format=long
# ## reading GPG-Key ID from stdout
# echo "Please copy and paste the GPG primary key ID that you want to use"
# read GPG_PRIMARY_KEY_ID
# echo "Please copy and paste the GPG sub key id that you want to use"
# read GPG_SUB_KEY_ID
# gpg --armor --export  $GPG_PRIMARY_KEY_ID
# git config --global user.signingkey $GPG_PRIMARY_KEY_ID
# git config --global user.signingkey "$GPG_SUB_KEY_ID\!"
# git config --global commit.gpgsign true
# # GPG Signing is buggy, switching to ssh instead

# Setting up git
cd ~/.ssh/
git config --global user.name "Rohan Batra"
git config --global user.email "116573125+rohanbatrain@users.noreply.github.com"
git config --global gpg.format ssh
git config --global commit.gpgsign true
ssh -T git@github.com

# Cloning github repositories
cd /sdcard
mkdir -p Github/Repositories 
cd Github/Repositories
git clone git@github.com:rohanbatrain/Second-Brain-Private.git 
git clone git@github.com:rohanbatrain/Dot-Files.git

# Obsidian Vault
cd /sdcard 
mkdir Obsidian
git clone git@github.com:rohanbatrain/Second-Brain-Private.git



# Symblinking
cd ~ && mkdir repositories && cd repositories 
## This for loop below is because i have to merge two of my github repos, which is not possible without symlinking or unionfs,
## both of which doesn't work on internal storage directory of termux.
## Why not other directory than internal? It's because i don't want my android apps to be given root access everytime i need these files,
## obsidian even doesn't officially recommend symlinks so root access probably expose to security issues.
mkdir obsidian && cd obsidian 
ln -s /sdcard/Obsidian/Second-Brain-Private/ .




