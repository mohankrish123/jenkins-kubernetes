FROM mohankrish3/nginx:4.0
COPY index.html /var/www/html
RUN chown -R www-data:www-data /var/www
