import redis
client=redis.Redis.from_url('redis://ttsecnew-ro.26vdzn.ng.0001.use2.cache.amazonaws.com:6379')
client.ping()
quit()
