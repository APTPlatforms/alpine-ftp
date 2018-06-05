#!/bin/sh

if [ -z "$PASV_ADDRESS" -o "$PASV_ADDRESS" = None ]
then
    PASV_ADDRESS=`curl -f -s http://169.254.169.254/latest/meta-data/public-ipv4`
    if [ $? -eq 0 ]
    then
        echo "Using meta-data public-ipv4 ($PASV_ADDRESS) value for PASV_ADDRESS"
    else
        echo "ERROR: PASV_ADDRESS must be set."
        exit 1
    fi
fi

if [ -z "$USER" -o "$USER" = None ]
then
    echo "ERROR: USER must be set."
    exit 1
fi

if [ -z "$PASS" -o "$PASS" = None ]
then
    echo "ERROR: PASS must be set."
    exit 1
fi

addgroup -g $GID -S $USER
adduser -u $UID -D -G $USER -h /data -s /bin/false $USER

echo "$USER:$PASS" | /usr/sbin/chpasswd
chown -R $USER:$USER /data/

augtool -s <<_EOT_
set /files/etc/vsftpd/vsftpd.conf/pasv_enable YES
set /files/etc/vsftpd/vsftpd.conf/pasv_addr_resolve YES
set /files/etc/vsftpd/vsftpd.conf/pasv_address $PASV_ADDRESS
set /files/etc/vsftpd/vsftpd.conf/pasv_min_port $PASV_MIN
set /files/etc/vsftpd/vsftpd.conf/pasv_max_port $PASV_MAX
_EOT_

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
