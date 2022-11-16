FROM neuvector/docs_base:latest

COPY grav /var/www/html 
COPY robots.txt /var/www/html
COPY .htaccess /var/www/html
RUN chown -R www-data /var/www/html && chgrp -R www-data /var/www/html

