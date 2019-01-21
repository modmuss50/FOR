os.loadAPI("json.lua")

local apiURL = "https://for.ftb.world/api/stations/"

--Gets around caching
function getUrlSuffix()
    return ("?t=" .. math.random(1, 1000000))
end

function httpGet(path)
    local getReq = http.get(apiURL .. path .. getUrlSuffix())
    local str = getReq.readAll()
    if str == nil then
        error("invalid response")
    end
    local response = json.decode(str)
    return response
end

function httpPost(path, data)
    local body = json.encode(data)
    local postReq = http.post(apiURL .. path .. getUrlSuffix(), body)
    local str = postReq.readAll()
    if str == nil then
        error("invalid response")
    end
    local response  = json.decode(str)
    return response
end

function httpPostAsync(path, data)
    local body = json.encode(data)
    http.request(apiURL .. path .. getUrlSuffix(), body)
end

function startsWith(str, start)
    return str:sub(1, #start) == start
 end
 
 function endsWith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
 end
