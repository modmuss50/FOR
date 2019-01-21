os.loadAPI("json.lua")

local apiURL = "http://playground.gaz492.uk:8000/"

--Gets around caching
function getUrlSuffix()
    return ("?t=" .. math.random(1, 1000000))
end

function get(path)
    local get = http.get(apiURL .. path .. getUrlSuffix())
    local response  = json.decode(get.readAll())
    return response
end

function post(path, data)
    local body = json.encode(data)
    local post = http.post(apiURL .. path .. getUrlSuffix(), body)
    local response  = json.decode(post.readAll())
    return response
end

