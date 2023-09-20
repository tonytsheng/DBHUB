https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:41727263557318

Method 1: (the old/easy way)

select * from tab minus tab@remote_db;
select * from tab@remote_db minus tab;

Method 2: I learned from you; this is faster:

select count(1) from
(select 1, count(src1),count(src2)
from (select a.*, 1 src1, to_number(null) src2 from tt a
union all
select b.*, to_number(null) src1, 2 src2 from tt@optical1 b)
group by
OWNER,OBJECT_NAME,SUBOBJECT_NAME,OBJECT_ID,DATA_OBJECT_ID,OBJECT_TYPE,
CREATED,LAST_DDL_TIME,TIMESTAMP,STATUS,TEMPORARY,GENERATED,SECONDARY
having count(src1) <> count(src2)
);



However, if I knew in advance I'd be wanting to do this over and over, and I owned the table, I might store a hash with each row similar to what I've stated here

ops$tkyte@ORA10G> create or replace type myTabletype as table of raw(16)
2 /

Type created.

ops$tkyte@ORA10G>
ops$tkyte@ORA10G> create or replace function hash_emp_row return myTableType
2 PIPELINED
3 is
4 l_data long;
5 begin
6 for p_rec in ( select * from emp )
7 loop
8 l_data := p_rec.empno || '/' || p_rec.ename || '/' ||
9 p_rec.job || '/' || p_rec.mgr || '/' ||
10 to_char(p_rec.hiredate,'yyyymmddhh24miss')||'/'||
11 p_rec.sal || '/' || p_rec.comm || '/' || p_rec.deptno;
12
13 pipe row( dbms_crypto.hash( src => utl_raw.cast_to_raw(l_data), typ=>dbms_crypto.hash_sh1 ) );
14 end loop;
15 return;
16 end;
17 /

Function created.

ops$tkyte@ORA10G>
ops$tkyte@ORA10G> select * from table( hash_emp_row() );

COLUMN_VALUE
--------------------------------
938038876BA25B11B04E2C049AC5C2A2
CFC778EDE45768BEB61B167592B96F84
8C86638EDDD66C1E87CC4B5F543A3C58
979BF6885C038CAA467988806BC17ABB
D3CA2C3A8AADB09F6E2AFD9C8C908E7E
75F0F6F868387E36ED4EE822A9E1AC5D
D3ED8DB9B3A6089195ABEACFC94F1CC6
68AACD0483116F4FACCC47E2FD2F4574
93FB3DA7CCC7D56F71E7E42CC2BB90DD
EF70145942A55E5469621EBDC409D373
37D8CD7AFA0BC0F89E3F62F9EBCF7E3A
82AC70476C9E28A648166E88BFA246DB
598385613321685FF202CC20B3C86205
92E16DE14F8C430E7F06436D54B9E466

14 rows selected.

