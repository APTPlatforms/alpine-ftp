# vim:filetype=dockerfile
FROM alpine:3.7
LABEL maintainer="Chris Cosby <chris.cosby@aptplatforms.com>"

RUN apk update \
 && apk upgrade \
 && apk add vsftpd augeas tzdata curl

ENV USER=None \
    PASS=None \
    UID=1000 \
    GID=1000 \
    PASV_ADDRESS=None \
    PASV_MIN=21100 \
    PASV_MAX=21110

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 21/tcp ${PASV_MIN}-${PASV_MAX}/tcp

VOLUME /data

CMD sh /docker-entrypoint.sh
