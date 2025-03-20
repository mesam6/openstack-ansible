# openstack-ansible
## Install Openstack using Ansible Playbooks

Log into your EC2 instance and run: 
```
bash deploy-openstack-ansible.sh
```
The script will do following:
- Install Ansible and required python modules
- Install Openstack Stack with localhost environment
- Creates a private and public network with dummy IPs
- Creates routes 
- Adds basic firewall
- Creates SSHK key and test instance
