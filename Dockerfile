
FROM php:apache

LABEL Name=migoller/ltbssp Version=0.8.0

ENV DEBIAN_FRONTEND noninteractive

# Install additional packages
RUN apt-get -y update && apt-get install -y \
    git \
    libmcrypt-dev \
    libldap2-dev \
    sendmail

RUN apt-get clean

# Install the PHP mcrypt extention
RUN pecl install mcrypt-1.0.1 && \
    docker-php-ext-enable mcrypt

# Install the LDAP mcrypt extention
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
    docker-php-ext-install ldap

# Install the MBSTRING mcrypt extention
RUN docker-php-ext-install mbstring

# Set the working dir
WORKDIR /var/www/html

# Clone the "LDAP Tool Box Self Service Password" repository
RUN mkdir master_temp
RUN git clone https://github.com/ltb-project/self-service-password.git master_temp
RUN cp -R -f master_temp/* .
RUN rm -rf $distro master_temp

# Create directory for LTBSSP script files
RUN mkdir -p /usr/share/self-service-password

# Add customization files for custom docker images.
ADD ./customization/conf ./conf
ADD ./customization/css ./css
ADD ./customization/images ./images
ADD ./customization/scripts /usr/share/self-service-password

# Define the exposed ports
EXPOSE 80
