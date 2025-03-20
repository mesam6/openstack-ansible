#!/bin/bash
# This script installs Ansible and runs playbooks to deploy Openstack on your EC2 Instance
#

# Install Ansible
sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# Run playbook to create Openstack stack
ansible-playbook -i inventory.yaml playbooks/site.yml

# create public and private networking
openstack network create public --external --provider-network-type flat --provider-physical-network physnet1
openstack subnet create public-subnet --network public --subnet-range 192.168.1.0/24 --gateway 192.168.1.1 --allocation-pool start=192.168.1.100,end=192.168.1.200 --dns-nameserver 8.8.8.8
openstack network create private openstack subnet create private-subnet --network private --subnet-range 10.0.0.0/24 --dns-nameserver 8.8.8.8

# firewall for openstack
openstack security group create allow-ssh-icmp
openstack security group rule create --proto tcp --dst-port 22 allow-ssh-icmp
openstack security group rule create --proto icmp allow-ssh-icmp 

# create network routes
openstack router create public-router
openstack router set public-router --external-gateway public
openstack router add subnet public-router private-subnet

# verify networking setup 
openstack network list
openstack subnet list
openstack router show public-router
openstack security group list
openstack security group rule list allow-ssh-icmp

# test create openstack
ssh-keygen -t rsa -b 4096 -f my_openstack_key
openstack keypair create --public-key dev_openstack_key.pub dev_openstack_key
openstack server create --image ubuntu-22.04 --flavor m1.small --key-name dev_openstack_key --network private instance-01


