import redis
client = redis.Redis.from_url('redis://ttsecnew.26vdzn.ng.0001.use2.cache.amazonaws.com:6379')
client.ping()

