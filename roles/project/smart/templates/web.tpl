#!/bin/bash -v
sudo su -
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-14da66dd.efs.eu-west-1.amazonaws.com:/ /var/lib/jenkins/
/etc/init.d/jenkins restart
