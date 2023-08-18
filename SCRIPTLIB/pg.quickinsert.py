import psycopg2
import random

conn = psycopg2.connect(host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com",database="pg102", user="postgres",password="Pass1234",port=5432)
create = conn.cursor()
create.execute("""CREATE TABLE IF NOT EXISTS log (id int, dttm timestamp, value text);""")
conn.commit()

month=random.randint(1,12)
day=random.randint(1,28)
year=random.randint(2018,2020)
hour=random.randint(0,23)
minute=0
second=0

for val in range(0,10000000):    
    cur = conn.cursor()    
    second += 1    
#    print (second)
    if second == 60:        
        second = 0        
        minute +=1        
    if minute == 60:            
        minute = 0            
        hour += 1            
    if hour == 24:                
        hour = 0    

    ts="{}-{}-{} {}:{}:{}".format(year,month,day,hour,minute,second)    
    cur.execute("INSERT INTO log VALUES (%s,%s,%s)", (val,ts,'PY_INSERT'));    
    print ("insert")
    conn.commit()        
    print ("commit")

if val % 10000 == 0:        
   print("Commit batch:",val)        
# Next date range for next batch        
month=random.randint(1,12)        
day=random.randint(1,28)        
year=random.randint(2018,2020)        
hour=random.randint(0,23)        
minute=0        
second=0

