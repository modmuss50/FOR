os.loadAPI("json.lua")
os.loadAPI("touchpoint.lua")

local apiURL = "http://localhost:9999/"

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
    local response = json.decode(str)
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
    return ending == "" or str:sub(-(#ending)) == ending
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

local page = 1
local pages = 1

function list(entrys, title, term, cPage)
    term = term or false
    cPage = cPage or 1
    local t = nil
    if term then
        t = touchpoint.newTerm()
    else
        t = touchpoint.new()
    end

    page = cPage
    pages = math.ceil(utils.tablelength(entrys) / 4)
    
    t:add(title, nil, 1, 2, 39, 2, colors.green, colors.white)

    t:add("Page: " .. page .. "/" .. pages, nil, 1, 3, 39, 3, colors.gray, colors.gray, colors.lime, colors.lime)

    for i = 1, 4 do
        local y = 1 + (i * 3)
        local color = colors.red
        local textColor = colors.white
        if i % 2 == 0 then
            color = colors.pink
            textColor = colors.black
        end
        local entryName = entrys[i + ((page - 1) * 4)]
        if entryName then
            t:add("#" .. entryName, nil, 1, y, 39, y + 2, color, color, textColor, textColor)
        end
    end

    if not (page == 1) then
        t:add("Previous Page", nil, 1, 17, 19, 19, colors.orange, colors.orange, colors.black, colors.black)
    end

    if not (page == pages) then
        t:add("Next Page", nil, 20, 17, 39, 19, colors.magenta, colors.magenta, colors.black, colors.black)
    end

    t:draw()

    while true do
        local event, button = t:handleEvents(os.pullEvent())
        if event == "button_click" then
            if utils.startsWith(button, "#") then
                return button:gsub("#", "")
            end
            if button == "Next Page" then
                page = page + 1
                return list(entrys, title, term, page)
            end
            if button == "Previous Page" then
                page = page - 1
                return list(entrys, title, term, page)
            end
        end
    end
end

function message(text, time, col)
    time = time or 3
    col = col or colors.green

    local t = touchpoint.new()
    t:add(text, nil, 1, 1, 39, 19, col, col)
    t:draw()
    sleep(time)
end

function messageTerm(text, time, col)
    time = time or 3
    col = col or colors.green

    local t = touchpoint.newTerm()
    t:add(text, nil, 1, 1, 39, 19, col, col)
    t:draw()
    sleep(time)
end

function readValue(name)
    print("Enter " .. name .. ":")
    return read()
end
