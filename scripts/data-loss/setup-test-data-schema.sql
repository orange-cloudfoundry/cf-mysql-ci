DROP DATABASE IF EXISTS mysql_data_loss_test;

CREATE DATABASE mysql_data_loss_test;

USE mysql_data_loss_test;

CREATE TABLE `test_table` (
  `id` int unsigned NOT NULL,
  `text` TEXT(1048576) NOT NULL,
  PRIMARY KEY (`id`)
);
