# requester.py
import httpx

async def requester(api_url, timeout=300):
    async with httpx.AsyncClient(timeout=timeout) as client:
        try:
            response = await client.get(api_url)
            return response.json() if response.status_code == 200 else None
        except httpx.HTTPError:
            return None
