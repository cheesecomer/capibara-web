
CREATE DATABASE capibara_development;
CREATE DATABASE capibara_test;
CREATE USER 'capibara_dev'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'capibara_test'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON capibara_development.* TO 'capibara_dev'@'localhost';
GRANT ALL PRIVILEGES ON capibara_test.* TO 'capibara_test'@'localhost';