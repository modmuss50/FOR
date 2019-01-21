os.loadAPI("json.lua")

local apiURL = "http://playground.gaz492.uk:8000/"

function get(path)
    local get = http.get(path)
    local response  = json.decode(get.readAll())
    return response
end

function post(path, data)
    local body = json.encode(data)
    local post = http.post(apiURL .. path, body)
    local response  = json.decode(post.readAll())
    return response
end