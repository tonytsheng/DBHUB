import redis
client=redis.Redis.from_url('redis://ttsheng-ec1-001.26vdzn.0001.use2.cache.amazonaws.com:6379')
client.ping()
quit()
