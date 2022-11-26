CREATE TABLE docs (id NUMBER PRIMARY KEY, text VARCHAR2(200));
CREATE INDEX idx_docs ON docs(text)
     INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS
     ('FILTER CTXSYS.NULL_FILTER SECTION GROUP CTXSYS.HTML_SECTION_GROUP');

INSERT INTO docs VALUES(1, '<HTML>California is a state in the US.</HTML>');
INSERT INTO docs VALUES(2, '<HTML>Paris is a city in France.</HTML>');
INSERT INTO docs VALUES(3, '<HTML>France is in Europe.</HTML>');

SELECT SCORE(1), id, text FROM docs WHERE CONTAINS(text, 'France', 1) > 0;

INSERT INTO docs VALUES(4, '<HTML>Los Angeles is a city in California.</HTML>');
INSERT INTO docs VALUES(5, '<HTML>Mexico City is big.</HTML>');

SELECT SCORE(1), id, text FROM docs WHERE CONTAINS(text, 'city', 1) > 0;
EXEC CTX_DDL.SYNC_INDEX('idx_docs', '2M');
SELECT SCORE(1), id, text FROM docs WHERE CONTAINS(text, 'city', 1) > 0;
