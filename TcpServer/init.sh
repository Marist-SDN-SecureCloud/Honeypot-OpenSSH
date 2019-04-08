#/bin/bash
# Author:  Daniel Nicolas Gisolfi

# Turn both ssh servers on 
/usr/local/sbin/sshd-22 -f /usr/local/etc/sshd_config-22
/usr/local/sbin/sshd-2222 -f /usr/local/etc/sshd_config-2222

# Enable the TCP server
python3 -u server.py