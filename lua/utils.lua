os.loadAPI("json.lua")

local apiURL = "http://playground.gaz492.uk:8000/"

--Gets around caching
function getUrlSuffix()
    return ("?t=" .. math.random(1, 1000000))
end

function httpGet(path)
    local get = http.get(apiURL .. path .. getUrlSuffix())
    local str = get.readAll()
    if str == nil then
        error("invalid response")
    end
    local response = json.decode(str)
    return response
end

function post(path, data)
    local body = json.encode(data)
    local post = http.post(apiURL .. path .. getUrlSuffix(), body)
    local str = post.readAll()
    if str == nil then
        error("invalid response")
    end
    local response  = json.decode(str)
    return response
end
