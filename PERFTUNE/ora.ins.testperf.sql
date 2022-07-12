set serveroutput on;
DECLARE
  l_lookup_id    NUMBER(10);
  l_create_date  DATE;
BEGIN
  FOR i IN 1 .. 10000000 LOOP
    IF MOD(i, 3) = 0 THEN
      l_create_date := ADD_MONTHS(SYSDATE, -24);
      l_lookup_id   := 2;
    ELSIF MOD(i, 2) = 0 THEN
      l_create_date := ADD_MONTHS(SYSDATE, -12);
      l_lookup_id   := 1;
    ELSE
      l_create_date := SYSDATE;
      l_lookup_id   := 3;
    END IF;

    INSERT INTO testperf.bigtab (id, created_date, lookup_id, comments)
    VALUES (i, l_create_date, l_lookup_id, 'This is some dummy data for test performance insights' || i);
  END LOOP;
  COMMIT;
END;
/
exit

