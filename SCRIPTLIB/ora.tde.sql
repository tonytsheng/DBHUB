SELECT * FROM V$ENCRYPTION_WALLET;

SELECT * FROM V$ENCRYPTION_KEYS;

SELECT WRL_PARAMETER,STATUS,WALLET_TYPE FROM V$ENCRYPTION_WALLET;
SELECT KEY_ID,KEYSTORE_TYPE FROM V$ENCRYPTION_KEYS;

SELECT KEY_ID FROM V$ENCRYPTION_KEYS;
SELECT KEYSTORE_TYPE FROM V$ENCRYPTION_KEYS;

SELECT WRL_PARAMETER FROM V$ENCRYPTION_WALLET;
SELECT STATUS FROM V$ENCRYPTION_WALLET;

SELECT * FROM V$ENCRYPTED_TABLESPACES;
SELECT TABLESPACE_NAME, ENCRYPTED FROM DBA_TABLESPACES;
SELECT * FROM DBA_ENCRYPTED_COLUMNS;
