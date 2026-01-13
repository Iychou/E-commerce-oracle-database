CONN / AS SYSDBA;

-- UNDO
CREATE UNDO TABLESPACE undotbs1


DATAFILE 'undotbs01.dbf'
SIZE 500M AUTOEXTEND ON;

ALTER SYSTEM SET UNDO_TABLESPACE = undotbs1;

-- Active Sessions
SELECT sid, serial#, username, status FROM v$session;

-- SQL exécuté par session
SELECT s.sid, q.sql_text
FROM v$session s JOIN v$sql q
ON s.sql_id = q.sql_id;

-- Requêtes les plus coûteuses
SELECT sql_text, executions, elapsed_time
FROM v$sql
ORDER BY elapsed_time DESC;

-- Activer ARCHIVELOG
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

-- Fast Recovery Area
ALTER SYSTEM SET db_recovery_file_dest_size = 10G;
ALTER SYSTEM SET db_recovery_file_dest = '/u01/fra';

-- RMAN
RMAN TARGET /

BACKUP DATABASE PLUS ARCHIVELOG;

BACKUP INCREMENTAL LEVEL 1 DATABASE;
