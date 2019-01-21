os.loadAPI("json.lua")
os.loadAPI("utils.lua")
os.loadAPI("touchpoint.lua")

local dataFile = "station.json"


local function readValue(name)
    print("Enter " .. name .. ":")
    return read()
end

local function setup()
    print("Station data not found, station setup tool:")
    local data = {
        name = readValue("station name"),
        pos = {
            x = readValue("x pos"),
            y = readValue("y pos"), 
            z = readValue("z pos"),
        }
    }

    data.id = data.pos.x .. "," .. data.pos.y .. "," .. data.pos.z

    json.encodeToFile(dataFile, data)
end

local function stationMain()
    if not fs.exists(dataFile) then
        setup()
    end
    print("Reading station.json")
    data = json.decodeFromFile(dataFile)

    local t = touchpoint.new("right")

    t:add("Station: " .. data.name, nil, 1, 1, 1, 1, colors.lime, colors.white)

    -- t:add("test", nil, 2, 2, 14, 11, colors.red, colors.lime)

    -- t:add("test2", nil, 16, 2, 28, 11, colors.red, colors.lime)

    t:draw()

    while true do
        local event, button = t:handleEvents(os.pullEvent())
        if event == "button_click" then
                print(button .. " pressed")
        end
end

end

stationMain()
