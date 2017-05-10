
CREATE TABLE `test_table` (
  `id` mediumint(8) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `text` TEXT NOT NULL,
  PRIMARY KEY (`id`)
);

SOURCE test-data.sql
