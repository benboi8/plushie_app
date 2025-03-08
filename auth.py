# auth.py

def auth_and_rate_limit(func):
    async def wrapper(request, *args, **kwargs):
        api_key = request.query_params.get("api_key")
        if not api_key or api_key != "valid_api_key":
            return {"status": False, "message": "Invalid API Key"}
        return await func(request, *args, **kwargs)
    return wrapper
