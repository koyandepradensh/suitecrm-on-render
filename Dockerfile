# Use official PHP-Apache base image
FROM php:7.4-apache

# Install required PHP extensions and tools
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    mariadb-client \
    && docker-php-ext-install pdo pdo_mysql zip mbstring gd xml intl \
    && apt-get clean




# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory (optional)
WORKDIR /var/www/html

# Copy all SuiteCRM files to the Apache web root
COPY . /var/www/html/

# Fix permissions (important for SuiteCRM)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Set DirectoryIndex in case Apache config misses it
RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf

RUN echo "<Directory /var/www/html>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" > /etc/apache2/conf-available/allow.conf && a2enconf allow

# Expose port 80
EXPOSE 80
