# main.py
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import asyncio
import datetime
from config import API_SERVER_URLS
from redis_cache import redis_cache
from requester import requester
from auth import auth_and_rate_limit
import email_process

app = FastAPI()

@app.post("/{path:path}", include_in_schema=False)
@auth_and_rate_limit
async def v1_gateway(request: Request, path: str):
    api_key = request.query_params.get('api_key')
    _path = f"/{path}"
 
    api_urls = [f'{api_server_url}/{path}' for api_server_url in API_SERVER_URLS]

    # Check Redis Cache
    tasks = [redis_cache.get(key=api_url, timeout=300) for api_url in api_urls]
    cached_responses = await asyncio.gather(*tasks)

    for i, response in enumerate(cached_responses):
        if response:
            return JSONResponse(content=response, status_code=200)

    # Fetch data from backend APIs
    try:
        tasks = [requester(api_url=api_url, timeout=300) for api_url in api_urls]
        responses = await asyncio.gather(*tasks)
    except:
        responses = []

    for i, response in enumerate(responses):
        if response and response.get("status", False):
            await redis_cache.set(key=api_urls[i], value=response, ttl=3600)
            return JSONResponse(content=response, status_code=200)

    # Log failure and notify developers
    message = "All API Servers failed to respond."
    _args = {"message_type": "resource_not_found", "request": request, "api_key": api_key}
    await email_process.send_message_to_devs(**_args)

    return JSONResponse(content={"status": False, "message": message}, status_code=404)

