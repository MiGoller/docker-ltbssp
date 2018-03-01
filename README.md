# Docker image for LDAP Tool Box Self Service Password
This docker image is designed to run the famous [LDAP Tool Box Self Service Password](https://ltb-project.org/documentation/self-service-password).
Based on the latest official PHP-image the build process of the image will clone the current master branch of LDAP Tool Box Self Service Password into it's runtime environment. You'll get the current stable PHP running the current build of LTBSSP.
Many thanks to [LTB project group](https://ltb-project.org/start).

Enjoy!

## Running this image
For many simple, single file projects, you may find it inconvenient to write a complete Dockerfile for your own image. In such cases, you can run a LTBSSP instance by using the Docker image directly:
```
$ docker run -it --rm --name my-ltbssp \
    -p 80:80 \
    -v "$PWD/config":/var/www/html/conf \
    migoller/ltbssp
```
The image contains the default configuration file [config.inc.php](https://github.com/ltb-project/self-service-password/blob/master/conf/config.inc.php) of the current master branch for demonstration purposes. 
I recommend to "inject" your own configuration file using a volume mount to a host directory for example.
1. Create a configuration directory on the docker host (e.g. mkdir config)
2. Download the file [config.inc.php](https://github.com/ltb-project/self-service-password/blob/master/conf/config.inc.php) to the created directory.
3. Modify the configuartion file to fit your needs. 

## Customizing the image
If you want to customize the look and feel of the LTBSSP you'll have to build a custom image. 

### Prepare to customize the image
Just follow these steps to add your files to a custom image.
1. Clone the git repo to your dev host: ```$ git clone https://github.com/MiGoller/docker-ltbssp.git .```
2. I do not recommend but you may want to put your configuration into the image. If you want to do so just drop your configuration file to ```./customization/conf/config.inc.php``` .
3. Place any custom css files to the directory ```./customization/css``` .
4. Place any custom image files to the directory ```./customization/images``` .
5. Place any custom script files to the directory ```./customization/scripts``` .

### Building the custom image
TBD!

# Running LTBSSP behind a reverse proxy
I highly recommend to run the LTBSSP behind an [Automated Nginx reverse proxy for docker containers](https://hub.docker.com/r/jwilder/nginx-proxy/) for SSL-encryption and protection of the PHP-container.

# Configuration settings for LDAP Tool Box Self Service Password
Have a look at the [LTB Self Service Password documentation](https://ltb-project.org/documentation/self-service-password/latest/start) for all configuation options. You should at least adjust your [LDAP connection settings](https://ltb-project.org/documentation/self-service-password/latest/config_ldap) of your configuration file.
```
# LDAP
$ldap_url = "ldap://localhost";
$ldap_starttls = false;
$ldap_binddn = "cn=manager,dc=example,dc=com";
$ldap_bindpw = "secret";
$ldap_base = "dc=example,dc=com";
$ldap_login_attribute = "uid";
$ldap_fullname_attribute = "cn";
$ldap_filter = "(&(objectClass=person)($ldap_login_attribute={login}))";
```
Check the hash settings as well. A "clear" password is not really a good idea! Probably ```$hash = "auto"``` will do the trick for you.
```
# Hash mechanism for password:
# SSHA, SSHA256, SSHA384, SSHA512
# SHA, SHA256, SHA384, SHA512
# SMD5
# MD5
# CRYPT
# clear (the default)
# auto (will check the hash of current password)
# This option is not used with ad_mode = true
$hash = "clear";
```
And don't forget to change the default keyphrase to anything long, random and complicated!
```
# Encryption, decryption keyphrase, required if $crypt_tokens = true
# Please change it to anything long, random and complicated, you do not have to remember it
# Changing it will also invalidate all previous tokens and SMS codes
$keyphrase = "secret";
```
