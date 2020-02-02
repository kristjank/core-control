#!/usr/bin/env bash

sudo sed -i "s/.*RSAAuthentication.*/RSAAuthentication yes/g" /etc/ssh/sshd_config
sudo sed -i "s/.*PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sudo sed -i "s/.*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/g" /etc/ssh/sshd_config
sudo sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication no/g" /etc/ssh/sshd_config
sudo sed -i "s/.*UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
sudo sed -i "s/.*PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config

sudo systemctl reload ssh
