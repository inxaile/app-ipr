USE sys;

DROP PROCEDURE IF EXISTS set_as_master;

CREATE USER IF NOT EXISTS 'sa'@'%'IDENTIFIED BY 'pass';
GRANT ALL PRIVILEGES ON *.* TO 'sa'@'%' WITH GRANT OPTION;

CREATE USER IF NOT EXISTS 'app'@'%'IDENTIFIED BY 'pass';
GRANT ALL PRIVILEGES ON *.* TO 'app'@'%' WITH GRANT OPTION;

CREATE USER IF NOT EXISTS 'haproxy'@'%'IDENTIFIED BY 'pass';
GRANT SELECT ON performance_schema.replication_group_members TO 'haproxy'@'%';

DELIMITER $$
CREATE PROCEDURE set_as_master ()
BEGIN
  SET @@GLOBAL.group_replication_bootstrap_group=1;
  CREATE USER IF NOT EXISTS 'repl'@'%';
  GRANT REPLICATION SLAVE ON *.* TO repl@'%';
  flush privileges;
  change master to master_user='root' for channel 'group_replication_recovery';
  START GROUP_REPLICATION;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS set_as_slave;

DELIMITER $$
CREATE PROCEDURE set_as_slave ()
BEGIN
  change master to master_user='repl' for channel 'group_replication_recovery';
  START GROUP_REPLICATION;
  SET @@global.read_only=1;
END $$
DELIMITER ;
