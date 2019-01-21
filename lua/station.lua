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
            z = readValue("z pos")
        }
    }

    data.id = data.pos.x .. "," .. data.pos.y .. "," .. data.pos.z

    json.encodeToFile(dataFile, data)
end

local function message(text, time, col)
    time = time or 3
    col = col or colors.green

    local t = touchpoint.new()
    t:add(text, nil, 1, 1, 39, 19, col, col)
    t:draw()
    sleep(time)
end

local function travel(destination)
    message("Traveling to " .. destination, 1)
    message("Printing ticket", 1)
    
    local ticketMachine = peripheral.find("ticket_machine")
    ticketMachine.setSelectedTicket(1)
    ticketMachine.setDestination(1, destination)
    local printed, error = ticketMachine.printTicket(10)
    if not printed then
        message("Failed to print:" .. error, 5, colors.red)
    end
end

local function drawScreen(data, stations)
    local t = touchpoint.new()
    t:add("This Station: " .. data.name, nil, 1, 1, 39, 1, colors.lime, colors.white)
    t:add("  Select Destination:", nil, 1, 2, 39, 2, colors.green, colors.white)

    t:add(" ", nil, 1, 3, 39, 3, colors.gray, colors.gray, colors.gray, colors.gray)

    for i = 1, #stations do
        local y = 1 + (i * 3)
        local color = colors.red
        local textColor = colors.white
        if i % 2 == 0 then
            color = colors.pink
            textColor = colors.black
        end
        t:add("#" .. stations[i] , nil, 1, y, 39, y + 2, color, color, textColor, textColor)
    end

    t:add("Previous Page", nil, 1, 17, 19, 19, colors.orange, colors.orange, colors.black, colors.black)
    t:add("Next Page", nil, 20, 17, 39, 19, colors.magenta, colors.magenta, colors.black, colors.black)

    t:draw()

    while true do
        local event, button = t:handleEvents(os.pullEvent())
        if event == "button_click" then
            if utils.startsWith(button, "#") then
                travel(button)
                break
            end
        end
    end
end

local function stationMain()
    if not fs.exists(dataFile) then
        setup()
    end
    print("Reading station.json")
    data = json.decodeFromFile(dataFile)

    local stations = {
        "Test",
        "Station 2",
        "Someone Else"
    }

    local ticketMachine = peripheral.find("ticket_machine")
    ticketMachine.setManualPrintingAllowed(false)

    drawScreen(data, stations)
end

while true do
    stationMain()
end

