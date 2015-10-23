
CREATE TABLE `test_table` (
  `id` mediumint(8) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `text` TEXT NOT NULL,
  PRIMARY KEY (`id`)
);

LOAD DATA LOCAL INFILE 'test-data.csv'
  INTO TABLE test_table
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n';