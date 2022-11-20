use fly1
go
INSERT INTO employee VALUES 
        ( 100 , 'Steven' , 'King' , 'SKING' , '515.123.4567' , to_date('17-06-2003','DD/MM/YYYY' , 'AD_PRES' , 24000 , NULL , NULL , 90
        )

go
INSERT INTO employee VALUES 
        ( 101
        , 'Neena'
        , 'Kochhar'
        , 'NKOCHHAR'
        , '515.123.4568'
	, getdate()
--        , '21-09-2005' 
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        )

go
INSERT INTO employee VALUES 
        ( 102
        , 'Lex'
        , 'De Haan'
        , 'LDEHAAN'
        , '515.123.4569'
        , '13-01-2001' 
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        )

go
INSERT INTO employee VALUES 
        ( 103
        , 'Alexander'
        , 'Hunold'
        , 'AHUNOLD'
        , '590.423.4567'
        , '03-01-2006' 
        , 'IT_PROG'
        , 9000
        , NULL
        , 102
        , 60
        )

go
INSERT INTO employee VALUES 
        ( 104
        , 'Bruce'
        , 'Ernst'
        , 'BERNST'
        , '590.423.4568'
        , '21-05-2007' 
        , 'IT_PROG'
        , 6000
        , NULL
        , 103
        , 60
        )

go
INSERT INTO employee VALUES 
        ( 105
        , 'David'
        , 'Austin'
        , 'DAUSTIN'
        , '590.423.4569'
        , '25-06-2005' 
        , 'IT_PROG'
        , 4800
        , NULL
        , 103
        , 60
        )

go
INSERT INTO employee VALUES 
        ( 106
        , 'Valli'
        , 'Pataballa'
        , 'VPATABAL'
        , '590.423.4560'
        , '05-02-2006' 
        , 'IT_PROG'
        , 4800
        , NULL
        , 103
        , 60
        )

go
INSERT INTO employee VALUES 
        ( 107
        , 'Diana'
        , 'Lorentz'
        , 'DLORENTZ'
        , '590.423.5567'
        , '07-02-2007' 
        , 'IT_PROG'
        , 4200
        , NULL
        , 103
        , 60
        )

go
INSERT INTO employee VALUES 
        ( 108
        , 'Nancy'
        , 'Greenberg'
        , 'NGREENBE'
        , '515.124.4569'
        , '17-08-2002' 
        , 'FI_MGR'
        , 12008
        , NULL
        , 101
        , 100
        )

go
INSERT INTO employee VALUES 
        ( 109
        , 'Daniel'
        , 'Faviet'
        , 'DFAVIET'
        , '515.124.4169'
        , '16-08-2002' 
        , 'FI_ACCOUNT'
        , 9000
        , NULL
        , 108
        , 100
        )

go
INSERT INTO employee VALUES 
        ( 110
        , 'John'
        , 'Chen'
        , 'JCHEN'
        , '515.124.4269'
        , '28-09-2005' 
        , 'FI_ACCOUNT'
        , 8200
        , NULL
        , 108
        , 100
        )

go
INSERT INTO employee VALUES 
        ( 111
        , 'Ismael'
        , 'Sciarra'
        , 'ISCIARRA'
        , '515.124.4369'
        , '30-09-2005' 
        , 'FI_ACCOUNT'
        , 7700
        , NULL
        , 108
        , 100
        )

go
INSERT INTO employee VALUES 
        ( 112
        , 'Jose Manuel'
        , 'Urman'
        , 'JMURMAN'
        , '515.124.4469'
        , '07-03-2006' 
        , 'FI_ACCOUNT'
        , 7800
        , NULL
        , 108
        , 100
        )

go
INSERT INTO employee VALUES 
        ( 113
        , 'Luis'
        , 'Popp'
        , 'LPOPP'
        , '515.124.4567'
        , '07-12-2007' 
        , 'FI_ACCOUNT'
        , 6900
        , NULL
        , 108
        , 100
        )

go
INSERT INTO employee VALUES 
        ( 114
        , 'Den'
        , 'Raphaely'
        , 'DRAPHEAL'
        , '515.127.4561'
        , '07-12-2002' 
        , 'PU_MAN'
        , 11000
        , NULL
        , 100
        , 30
        )

go
INSERT INTO employee VALUES 
        ( 115
        , 'Alexander'
        , 'Khoo'
        , 'AKHOO'
        , '515.127.4562'
        , '18-05-2003' 
        , 'PU_CLERK'
        , 3100
        , NULL
        , 114
        , 30
        )

go
INSERT INTO employee VALUES 
        ( 116
        , 'Shelli'
        , 'Baida'
        , 'SBAIDA'
        , '515.127.4563'
        , '24-12-2005' 
        , 'PU_CLERK'
        , 2900
        , NULL
        , 114
        , 30
        )

go
INSERT INTO employee VALUES 
        ( 117
        , 'Sigal'
        , 'Tobias'
        , 'STOBIAS'
        , '515.127.4564'
        , '24-07-2005' 
        , 'PU_CLERK'
        , 2800
        , NULL
        , 114
        , 30
        )

go
INSERT INTO employee VALUES 
        ( 118
        , 'Guy'
        , 'Himuro'
        , 'GHIMURO'
        , '515.127.4565'
        , '15-11-2006' 
        , 'PU_CLERK'
        , 2600
        , NULL
        , 114
        , 30
        )

go
INSERT INTO employee VALUES 
        ( 119
        , 'Karen'
        , 'Colmenares'
        , 'KCOLMENA'
        , '515.127.4566'
        , '10-08-2007' 
        , 'PU_CLERK'
        , 2500
        , NULL
        , 114
        , 30
        )

go
INSERT INTO employee VALUES 
        ( 120
        , 'Matthew'
        , 'Weiss'
        , 'MWEISS'
        , '650.123.1234'
        , '18-07-2004' 
        , 'ST_MAN'
        , 8000
        , NULL
        , 100
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 121
        , 'Adam'
        , 'Fripp'
        , 'AFRIPP'
        , '650.123.2234'
        , '10-04-2005' 
        , 'ST_MAN'
        , 8200
        , NULL
        , 100
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 122
        , 'Payam'
        , 'Kaufling'
        , 'PKAUFLIN'
        , '650.123.3234'
        , '01-05-2003' 
        , 'ST_MAN'
        , 7900
        , NULL
        , 100
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 123
        , 'Shanta'
        , 'Vollman'
        , 'SVOLLMAN'
        , '650.123.4234'
        , '10-10-2005' 
        , 'ST_MAN'
        , 6500
        , NULL
        , 100
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 124
        , 'Kevin'
        , 'Mourgos'
        , 'KMOURGOS'
        , '650.123.5234'
        , '16-11-2007' 
        , 'ST_MAN'
        , 5800
        , NULL
        , 100
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 125
        , 'Julia'
        , 'Nayer'
        , 'JNAYER'
        , '650.124.1214'
        , '16-07-2005' 
        , 'ST_CLERK'
        , 3200
        , NULL
        , 120
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 126
        , 'Irene'
        , 'Mikkilineni'
        , 'IMIKKILI'
        , '650.124.1224'
        , '28-09-2006' 
        , 'ST_CLERK'
        , 2700
        , NULL
        , 120
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 127
        , 'James'
        , 'Landry'
        , 'JLANDRY'
        , '650.124.1334'
        , '14-01-2007' 
        , 'ST_CLERK'
        , 2400
        , NULL
        , 120
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 128
        , 'Steven'
        , 'Markle'
        , 'SMARKLE'
        , '650.124.1434'
        , '08-03-2008' 
        , 'ST_CLERK'
        , 2200
        , NULL
        , 120
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 129
        , 'Laura'
        , 'Bissot'
        , 'LBISSOT'
        , '650.124.5234'
        , '20-08-2005' 
        , 'ST_CLERK'
        , 3300
        , NULL
        , 121
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 130
        , 'Mozhe'
        , 'Atkinson'
        , 'MATKINSO'
        , '650.124.6234'
        , '30-10-2005' 
        , 'ST_CLERK'
        , 2800
        , NULL
        , 121
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 131
        , 'James'
        , 'Marlow'
        , 'JAMRLOW'
        , '650.124.7234'
        , '16-02-2005' 
        , 'ST_CLERK'
        , 2500
        , NULL
        , 121
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 132
        , 'TJ'
        , 'Olson'
        , 'TJOLSON'
        , '650.124.8234'
        , '10-04-2007' 
        , 'ST_CLERK'
        , 2100
        , NULL
        , 121
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 133
        , 'Jason'
        , 'Mallin'
        , 'JMALLIN'
        , '650.127.1934'
        , '14-06-2004' 
        , 'ST_CLERK'
        , 3300
        , NULL
        , 122
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 134
        , 'Michael'
        , 'Rogers'
        , 'MROGERS'
        , '650.127.1834'
        , '26-08-2006' 
        , 'ST_CLERK'
        , 2900
        , NULL
        , 122
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 135
        , 'Ki'
        , 'Gee'
        , 'KGEE'
        , '650.127.1734'
        , '12-12-2007' 
        , 'ST_CLERK'
        , 2400
        , NULL
        , 122
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 136
        , 'Hazel'
        , 'Philtanker'
        , 'HPHILTAN'
        , '650.127.1634'
        , '06-02-2008' 
        , 'ST_CLERK'
        , 2200
        , NULL
        , 122
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 137
        , 'Renske'
        , 'Ladwig'
        , 'RLADWIG'
        , '650.121.1234'
        , '14-07-2003' 
        , 'ST_CLERK'
        , 3600
        , NULL
        , 123
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 138
        , 'Stephen'
        , 'Stiles'
        , 'SSTILES'
        , '650.121.2034'
        , '26-10-2005' 
        , 'ST_CLERK'
        , 3200
        , NULL
        , 123
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 139
        , 'John'
        , 'Seo'
        , 'JSEO'
        , '650.121.2019'
        , '12-02-2006' 
        , 'ST_CLERK'
        , 2700
        , NULL
        , 123
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 140
        , 'Joshua'
        , 'Patel'
        , 'JPATEL'
        , '650.121.1834'
        , '06-04-2006' 
        , 'ST_CLERK'
        , 2500
        , NULL
        , 123
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 141
        , 'Trenna'
        , 'Rajs'
        , 'TRAJS'
        , '650.121.8009'
        , '17-10-2003' 
        , 'ST_CLERK'
        , 3500
        , NULL
        , 124
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 142
        , 'Curtis'
        , 'Davies'
        , 'CDAVIES'
        , '650.121.2994'
        , '29-01-2005' 
        , 'ST_CLERK'
        , 3100
        , NULL
        , 124
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 143
        , 'Randall'
        , 'Matos'
        , 'RMATOS'
        , '650.121.2874'
        , '15-03-2006' 
        , 'ST_CLERK'
        , 2600
        , NULL
        , 124
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 144
        , 'Peter'
        , 'Vargas'
        , 'PVARGAS'
        , '650.121.2004'
        , '09-07-2006' 
        , 'ST_CLERK'
        , 2500
        , NULL
        , 124
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 145
        , 'John'
        , 'Russell'
        , 'JRUSSEL'
        , '011.44.1344.429268'
        , '01-10-2004' 
        , 'SA_MAN'
        , 14000
        , .4
        , 100
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 146
        , 'Karen'
        , 'Partners'
        , 'KPARTNER'
        , '011.44.1344.467268'
        , '05-01-2005' 
        , 'SA_MAN'
        , 13500
        , .3
        , 100
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 147
        , 'Alberto'
        , 'Errazuriz'
        , 'AERRAZUR'
        , '011.44.1344.429278'
        , '10-03-2005' 
        , 'SA_MAN'
        , 12000
        , .3
        , 100
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 148
        , 'Gerald'
        , 'Cambrault'
        , 'GCAMBRAU'
        , '011.44.1344.619268'
        , '15-10-2007' 
        , 'SA_MAN'
        , 11000
        , .3
        , 100
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 149
        , 'Eleni'
        , 'Zlotkey'
        , 'EZLOTKEY'
        , '011.44.1344.429018'
        , '29-01-2008' 
        , 'SA_MAN'
        , 10500
        , .2
        , 100
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 150
        , 'Peter'
        , 'Tucker'
        , 'PTUCKER'
        , '011.44.1344.129268'
        , '30-01-2005' 
        , 'SA_REP'
        , 10000
        , .3
        , 145
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 151
        , 'David'
        , 'Bernstein'
        , 'DBERNSTE'
        , '011.44.1344.345268'
        , '24-03-2005' 
        , 'SA_REP'
        , 9500
        , .25
        , 145
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 152
        , 'Peter'
        , 'Hall'
        , 'PHALL'
        , '011.44.1344.478968'
        , '20-08-2005' 
        , 'SA_REP'
        , 9000
        , .25
        , 145
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 153
        , 'Christopher'
        , 'Olsen'
        , 'COLSEN'
        , '011.44.1344.498718'
        , '30-03-2006' 
        , 'SA_REP'
        , 8000
        , .2
        , 145
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 154
        , 'Nanette'
        , 'Cambrault'
        , 'NCAMBRAU'
        , '011.44.1344.987668'
        , '09-12-2006' 
        , 'SA_REP'
        , 7500
        , .2
        , 145
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 155
        , 'Oliver'
        , 'Tuvault'
        , 'OTUVAULT'
        , '011.44.1344.486508'
        , '23-11-2007' 
        , 'SA_REP'
        , 7000
        , .15
        , 145
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 156
        , 'Janette'
        , 'King'
        , 'JKING'
        , '011.44.1345.429268'
        , '30-01-2004' 
        , 'SA_REP'
        , 10000
        , .35
        , 146
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 157
        , 'Patrick'
        , 'Sully'
        , 'PSULLY'
        , '011.44.1345.929268'
        , '04-03-2004' 
        , 'SA_REP'
        , 9500
        , .35
        , 146
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 158
        , 'Allan'
        , 'McEwen'
        , 'AMCEWEN'
        , '011.44.1345.829268'
        , '01-08-2004' 
        , 'SA_REP'
        , 9000
        , .35
        , 146
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 159
        , 'Lindsey'
        , 'Smith'
        , 'LSMITH'
        , '011.44.1345.729268'
        , '10-03-2005' 
        , 'SA_REP'
        , 8000
        , .3
        , 146
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 160
        , 'Louise'
        , 'Doran'
        , 'LDORAN'
        , '011.44.1345.629268'
        , '15-12-2005' 
        , 'SA_REP'
        , 7500
        , .3
        , 146
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 161
        , 'Sarath'
        , 'Sewall'
        , 'SSEWALL'
        , '011.44.1345.529268'
        , '03-11-2006' 
        , 'SA_REP'
        , 7000
        , .25
        , 146
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 162
        , 'Clara'
        , 'Vishney'
        , 'CVISHNEY'
        , '011.44.1346.129268'
        , '11-11-2005' 
        , 'SA_REP'
        , 10500
        , .25
        , 147
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 163
        , 'Danielle'
        , 'Greene'
        , 'DGREENE'
        , '011.44.1346.229268'
        , '19-03-2007' 
        , 'SA_REP'
        , 9500
        , .15
        , 147
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 164
        , 'Mattea'
        , 'Marvins'
        , 'MMARVINS'
        , '011.44.1346.329268'
        , '24-01-2008' 
        , 'SA_REP'
        , 7200
        , .10
        , 147
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 165
        , 'David'
        , 'Lee'
        , 'DLEE'
        , '011.44.1346.529268'
        , '23-02-2008' 
        , 'SA_REP'
        , 6800
        , .1
        , 147
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 166
        , 'Sundar'
        , 'Ande'
        , 'SANDE'
        , '011.44.1346.629268'
        , '24-03-2008' 
        , 'SA_REP'
        , 6400
        , .10
        , 147
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 167
        , 'Amit'
        , 'Banda'
        , 'ABANDA'
        , '011.44.1346.729268'
        , '21-04-2008' 
        , 'SA_REP'
        , 6200
        , .10
        , 147
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 168
        , 'Lisa'
        , 'Ozer'
        , 'LOZER'
        , '011.44.1343.929268'
        , '11-03-2005' 
        , 'SA_REP'
        , 11500
        , .25
        , 148
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 169  
        , 'Harrison'
        , 'Bloom'
        , 'HBLOOM'
        , '011.44.1343.829268'
        , '23-03-2006' 
        , 'SA_REP'
        , 10000
        , .20
        , 148
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 170
        , 'Tayler'
        , 'Fox'
        , 'TFOX'
        , '011.44.1343.729268'
        , '24-01-2006' 
        , 'SA_REP'
        , 9600
        , .20
        , 148
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 171
        , 'William'
        , 'Smith'
        , 'WSMITH'
        , '011.44.1343.629268'
        , '23-02-2007' 
        , 'SA_REP'
        , 7400
        , .15
        , 148
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 172
        , 'Elizabeth'
        , 'Bates'
        , 'EBATES'
        , '011.44.1343.529268'
        , '24-03-2007' 
        , 'SA_REP'
        , 7300
        , .15
        , 148
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 173
        , 'Sundita'
        , 'Kumar'
        , 'SKUMAR'
        , '011.44.1343.329268'
        , '21-04-2008' 
        , 'SA_REP'
        , 6100
        , .10
        , 148
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 174
        , 'Ellen'
        , 'Abel'
        , 'EABEL'
        , '011.44.1644.429267'
        , '11-05-2004' 
        , 'SA_REP'
        , 11000
        , .30
        , 149
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 175
        , 'Alyssa'
        , 'Hutton'
        , 'AHUTTON'
        , '011.44.1644.429266'
        , '19-03-2005' 
        , 'SA_REP'
        , 8800
        , .25
        , 149
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 176
        , 'Jonathon'
        , 'Taylor'
        , 'JTAYLOR'
        , '011.44.1644.429265'
        , '24-03-2006' 
        , 'SA_REP'
        , 8600
        , .20
        , 149
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 177
        , 'Jack'
        , 'Livingston'
        , 'JLIVINGS'
        , '011.44.1644.429264'
        , '23-04-2006' 
        , 'SA_REP'
        , 8400
        , .20
        , 149
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 178
        , 'Kimberely'
        , 'Grant'
        , 'KGRANT'
        , '011.44.1644.429263'
        , '24-05-2007' 
        , 'SA_REP'
        , 7000
        , .15
        , 149
        , NULL
        )

go
INSERT INTO employee VALUES 
        ( 179
        , 'Charles'
        , 'Johnson'
        , 'CJOHNSON'
        , '011.44.1644.429262'
        , '04-01-2008' 
        , 'SA_REP'
        , 6200
        , .10
        , 149
        , 80
        )

go
INSERT INTO employee VALUES 
        ( 180
        , 'Winston'
        , 'Taylor'
        , 'WTAYLOR'
        , '650.507.9876'
        , '24-01-2006' 
        , 'SH_CLERK'
        , 3200
        , NULL
        , 120
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 181
        , 'Jean'
        , 'Fleaur'
        , 'JFLEAUR'
        , '650.507.9877'
        , '23-02-2006' 
        , 'SH_CLERK'
        , 3100
        , NULL
        , 120
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 182
        , 'Martha'
        , 'Sullivan'
        , 'MSULLIVA'
        , '650.507.9878'
        , '21-06-2007' 
        , 'SH_CLERK'
        , 2500
        , NULL
        , 120
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 183
        , 'Girard'
        , 'Geoni'
        , 'GGEONI'
        , '650.507.9879'
        , '03-02-2008' 
        , 'SH_CLERK'
        , 2800
        , NULL
        , 120
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 184
        , 'Nandita'
        , 'Sarchand'
        , 'NSARCHAN'
        , '650.509.1876'
        , '27-01-2004' 
        , 'SH_CLERK'
        , 4200
        , NULL
        , 121
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 185
        , 'Alexis'
        , 'Bull'
        , 'ABULL'
        , '650.509.2876'
        , '20-02-2005' 
        , 'SH_CLERK'
        , 4100
        , NULL
        , 121
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 186
        , 'Julia'
        , 'Dellinger'
        , 'JDELLING'
        , '650.509.3876'
        , '24-06-2006' 
        , 'SH_CLERK'
        , 3400
        , NULL
        , 121
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 187
        , 'Anthony'
        , 'Cabrio'
        , 'ACABRIO'
        , '650.509.4876'
        , '07-02-2007' 
        , 'SH_CLERK'
        , 3000
        , NULL
        , 121
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 188
        , 'Kelly'
        , 'Chung'
        , 'KCHUNG'
        , '650.505.1876'
        , '14-06-2005' 
        , 'SH_CLERK'
        , 3800
        , NULL
        , 122
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 189
        , 'Jennifer'
        , 'Dilly'
        , 'JDILLY'
        , '650.505.2876'
        , '13-08-2005' 
        , 'SH_CLERK'
        , 3600
        , NULL
        , 122
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 190
        , 'Timothy'
        , 'Gates'
        , 'TGATES'
        , '650.505.3876'
        , '11-07-2006' 
        , 'SH_CLERK'
        , 2900
        , NULL
        , 122
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 191
        , 'Randall'
        , 'Perkins'
        , 'RPERKINS'
        , '650.505.4876'
        , '19-12-2007' 
        , 'SH_CLERK'
        , 2500
        , NULL
        , 122
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 192
        , 'Sarah'
        , 'Bell'
        , 'SBELL'
        , '650.501.1876'
        , '04-02-2004' 
        , 'SH_CLERK'
        , 4000
        , NULL
        , 123
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 193
        , 'Britney'
        , 'Everett'
        , 'BEVERETT'
        , '650.501.2876'
        , '03-03-2005' 
        , 'SH_CLERK'
        , 3900
        , NULL
        , 123
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 194
        , 'Samuel'
        , 'McCain'
        , 'SMCCAIN'
        , '650.501.3876'
        , '01-07-2006' 
        , 'SH_CLERK'
        , 3200
        , NULL
        , 123
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 195
        , 'Vance'
        , 'Jones'
        , 'VJONES'
        , '650.501.4876'
        , '17-03-2007' 
        , 'SH_CLERK'
        , 2800
        , NULL
        , 123
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 196
        , 'Alana'
        , 'Walsh'
        , 'AWALSH'
        , '650.507.9811'
        , '24-04-2006' 
        , 'SH_CLERK'
        , 3100
        , NULL
        , 124
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 197
        , 'Kevin'
        , 'Feeney'
        , 'KFEENEY'
        , '650.507.9822'
        , '23-05-2006' 
        , 'SH_CLERK'
        , 3000
        , NULL
        , 124
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 198
        , 'Donald'
        , 'OConnell'
        , 'DOCONNEL'
        , '650.507.9833'
        , '21-06-2007' 
        , 'SH_CLERK'
        , 2600
        , NULL
        , 124
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 199
        , 'Douglas'
        , 'Grant'
        , 'DGRANT'
        , '650.507.9844'
        , '13-01-2008' 
        , 'SH_CLERK'
        , 2600
        , NULL
        , 124
        , 50
        )

go
INSERT INTO employee VALUES 
        ( 200
        , 'Jennifer'
        , 'Whalen'
        , 'JWHALEN'
        , '515.123.4444'
        , '17-09-2003' 
        , 'AD_ASST'
        , 4400
        , NULL
        , 101
        , 10
        )

go
INSERT INTO employee VALUES 
        ( 201
        , 'Michael'
        , 'Hartstein'
        , 'MHARTSTE'
        , '515.123.5555'
        , '17-02-2004' 
        , 'MK_MAN'
        , 13000
        , NULL
        , 100
        , 20
        )

go
INSERT INTO employee VALUES 
        ( 202
        , 'Pat'
        , 'Fay'
        , 'PFAY'
        , '603.123.6666'
        , '17-08-2005' 
        , 'MK_REP'
        , 6000
        , NULL
        , 201
        , 20
        )

go
INSERT INTO employee VALUES 
        ( 203
        , 'Susan'
        , 'Mavris'
        , 'SMAVRIS'
        , '515.123.7777'
        , '07-06-2002' 
        , 'HR_REP'
        , 6500
        , NULL
        , 101
        , 40
        )

go
INSERT INTO employee VALUES 
        ( 204
        , 'Hermann'
        , 'Baer'
        , 'HBAER'
        , '515.123.8888'
        , '07-06-2002' 
        , 'PR_REP'
        , 10000
        , NULL
        , 101
        , 70
        )

go
INSERT INTO employee VALUES 
        ( 205
        , 'Shelley'
        , 'Higgins'
        , 'SHIGGINS'
        , '515.123.8080'
        , '07-06-2002' 
        , 'AC_MGR'
        , 12008
        , NULL
        , 101
        , 110
        )

go
INSERT INTO employee VALUES 
        ( 206
        , 'William'
        , 'Gietz'
        , 'WGIETZ'
        , '515.123.8181'
        , '07-06-2002' 
        , 'AC_ACCOUNT'
        , 8300
        , NULL
        , 205
        , 110
        )

go
select count(*) from employee
go

