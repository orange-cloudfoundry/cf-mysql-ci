DELIMITER $$

DROP PROCEDURE IF EXISTS createtables;
CREATE PROCEDURE createtables()
BEGIN

  SET @ind = 0;
  label1: LOOP
    SET @ind = @ind + 1;
    SET @dropq = CONCAT('DROP TABLE IF EXISTS table', @ind);
    SELECT @dropq;
    SET @createq = CONCAT('CREATE TABLE table', @ind, ' (id int)');
    SELECT @createq;
    PREPARE stmt1 FROM @dropq;
    PREPARE stmt2 FROM @createq;
    EXECUTE stmt1;
    SELECT "STMT1";
    EXECUTE stmt2;
    SELECT "STMT2";
    DEALLOCATE PREPARE stmt1;
    DEALLOCATE PREPARE stmt2;
    IF @ind < 100000 THEN 
       ITERATE label1; 
    END IF; 
    LEAVE label1;
  END LOOP label1;

END

$$

DELIMITER ;

CALL createtables();
