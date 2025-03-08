@app.post("/{path:path}", include_in_schema=False)
@auth_and_rate_limit
async def v1_gateway(request, path):
    api_key: dict = request.query_params.get('api_key')
    _path = f"/{path}"
    await create_take_credit_args(api_key=api_key, path=_path)

    api_urls = [f'{api_server_url}/{path}' for api_server_url in api_server_urls]

    tasks = [redis_cache.get(key=api_url, timeout=60*5) for api_url in api_urls]
    cached_responses = await asyncio.gather(*tasks)

    for i, response in enumerate(cached_responses):
        if response is not None:
            app_logger.info(msg=f"Found cached response from {api_urls[i]}")
            return JSONResponse(content=response, status_code=200, headers={"Content-Type": "application/json"})

    try:

        # 5 minutes timeout on resource fetching from backend - some resources may take very long
        tasks = [requester(api_url=api_url, timeout=300) for api_url in api_urls]
        responses = await asyncio.gather(*tasks)

    except asyncio.CancelledError:
        responses = []
    except httpx.HTTPError as http_err:
        responses = []

    app_logger.info(msg=f"Request Responses returned : {len(responses)}")
    for i, response in enumerate(responses):
        if response and response.get("status", False):
            api_url = api_urls[i]
            # NOTE, Cache is being set to a ttl of one hour here
            await redis_cache.set(key=api_url, value=response, ttl=60 * 60)
            app_logger.info(msg=f"Server Responded for this Resource {api_url}")
            return JSONResponse(content=response, status_code=200, headers={"Content-Type": "application/json"})
        else:
            # The reason for this algorithm is because sometimes the cron server is busy this way no matter
            # what happens a response is returned
            app_logger.warning(msg=f"""
            Server Failed To Respond - Or Data Not Found
                Original Request URL : {api_urls[i]}
                Actual Response : {response}          
            """)

    mess = "All API Servers failed to respond - Or there is no Data for the requested resource and parameters"
    app_logger.warning(msg=mess)
    # TODO - send Notifications to developers that the API Servers are down - or something requests coming up empty handed
    _time = datetime.datetime.now().isoformat(sep="-")

    # TODO - create Dev Message Types - Like Fatal Errors, and etc also create Priority Levels
    _args = dict(message_type="resource_not_found", request=request, api_key=api_key)
    await email_process.send_message_to_devs(**_args)
    return JSONResponse(content={"status": False, "message": mess}, status_code=404,
                        headers={"Content-Type": "application/json"})


