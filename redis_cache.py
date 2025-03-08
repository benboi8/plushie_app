# redis_cache.py

import aioredis
import json
import config

class RedisCache:
    def __init__(self, host=config.REDIS_HOST, port=config.REDIS_PORT, db=config.REDIS_DB):
        self.redis = None
        self.host = host
        self.port = port
        self.db = db

    async def connect(self):
        self.redis = await aioredis.from_url(f"redis://{self.host}:{self.port}/{self.db}")

    async def get(self, key, timeout=300):
        if not self.redis:
            await self.connect()
        data = await self.redis.get(key)
        return json.loads(data) if data else None

    async def set(self, key, value, ttl=3600):
        if not self.redis:
            await self.connect()
        await self.redis.set(key, json.dumps(value), ex=ttl)

redis_cache = RedisCache()

