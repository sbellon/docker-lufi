![](https://framagit.org/luc/lufi/raw/master/themes/default/public/img/lufi128.png)

## Description
What is [lufi](https://framagit.org/luc/lufi) ?

Lufi means Let's Upload that FIle.

It stores files and allows you to download them.

Is that all? No. All the files are encrypted by the browser! It means that your files never leave your computer unencrypted. The administrator of the Lufi instance you use will not be able to see what is in your file, neither will your network administrator, or your ISP.

**This image does not contain root processes**

## Configuration
### Environments
* UID : choose uid for launching lufi (default : 991)
* GID : choose gid for launching lufi (default : 991)
* WEBROOT : webroot of lufi (default : /)
* SECRET : random string used to encrypt cookies (default : will be generated on the first run)
* MAX_FILE_SIZE : maximum file size of an uploaded file in bytes (default : 100 MB)
* CONTACT : Lufi instance contact (default : contact@domain.tld)
* REPORT : URL or an email address to receive file reports (default : report@domain.tld)
* DEFAULT_DELAY : default time limit for files in days (default : 1 (0 for unlimited))
* MAX_DELAY : number of days after which the files will be deleted (default : 0 for unlimited)
* INSTANCE_NAME : name for the instance (default : Lufi)
* THEME : theme for Lufi (default : default)
* ALLOW_PWD_ON_FILES : enable download password (default : 1 (0 => disable, 1 => enable))
* MAX_TOTAL_SIZE : maximum size of all files (default : 10 GB)
* POLICY_WHEN_FULL : behaviour when maximum size reached (default : warn)
* MAIL_HOST : send emails with SMTP host (default : smtp.example.org)
* MAIL_SENDER : address to use as sender (default : no-reply@lufi.io)

### Volumes
* /usr/lufi/lufi.conf : Lufi's configuration file is here
* /usr/lufi/data : Lufi's database is here
* /usr/lufi/files : location of uploaded files

### Ports
* 8081

## Usage
### Simple launch
```shell
docker run -d -p 8081:8081 sbellon/lufi
```
URI access : http://localhost:8081

### Advanced launch
```shell
docker run -d -p 8181:8081 \
    -v /docker/config/lufi/data:/usr/lufi/data \
    -v /docker/data/lufi:/usr/lufi/files \
    -e UID=1001 \
    -e GID=1001 \
    -e WEBROOT=/lufi \
    -e SECRET=$(date +%s | md5sum | head -c 32) \
    -e CONTACT=contact@mydomain.com \
    -e MAX_FILE_SIZE=250000000 \
    sbellon/lufi
```
URI access : http://localhost:8181/lufi

