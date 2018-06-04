# vsftpd-alpine
Docker image of vsftpd server based on Alpine 3.7

### Notes

The user's home directory is `/data`. That's where you want to mount your volumes.

### Example usage

```
docker run \
  --name vsftpd \
  -d \
  -e USER=www \
  -e PASS=my-password \
  -p 21:21 \
  -p 21100-21110:21100-21110 \
  aptplatforms/vsftpd-alpine
```

### Example usage in docker-compose file

```
version: '2'
services:
  vsftpd:
    image: aptplatforms/vsftpd-alpine
    ports:
      - "35000:21"
      - "21100-21110:21100-21110"
   volumes:
     - ftp-data:/data
   environment:
     USER: user
     PASS: my-password
```
