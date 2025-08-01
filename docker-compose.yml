version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: joomla-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: my-secret-pw
      MYSQL_DATABASE: joomla
      MYSQL_USER: joomla
      MYSQL_PASSWORD: joomla
    volumes:
      - mysql_data:/var/lib/mysql

  joomla:
    image: joomla
    container_name: joomla-web
    depends_on:
      - mysql
    ports:
      - "8080:80"
    environment:
      JOOMLA_DB_HOST: mysql
      JOOMLA_DB_USER: joomla
      JOOMLA_DB_PASSWORD: joomla
      JOOMLA_DB_NAME: joomla
    volumes:
      - ./joomla_data:/var/www/html

volumes:
  mysql_data:
  joomla_data:
