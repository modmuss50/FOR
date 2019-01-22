os.loadAPI("json.lua")
os.loadAPI("utils.lua")
os.loadAPI("touchpoint.lua")

local dataFile = "station.json"
local page = 1
local pages = 1
local stations


local function setup()
    print("Station data not found, station setup tool:")
    local data = {
        name = utils.readValue("station name")
    }

    data.id = tonumber(utils.readValue("x pos")) .. "," .. tonumber(utils.readValue("y pos")) .. "," .. tonumber(utils.readValue("z pos"))

    local response = utils.httpPost("station/new", data)
    if not response.status == "success" then
        error(response.status)
    end

    json.encodeToFile(dataFile, data)
end

local function travel(destination)
    utils.message("Traveling to " .. destination, 1)
    utils.message("Printing ticket", 1)

    local ticketMachine = peripheral.find("ticket_machine")
    ticketMachine.setSelectedTicket(1)
    ticketMachine.setDestination(1, destination)
    local printed, error = ticketMachine.printTicket(1)
    if not printed then
        utils.message("Failed to print:" .. error, 5, colors.red)
    end
end

local function drawScreen(data)
    local t = touchpoint.new()
    t:add("This Station: " .. data.name, nil, 1, 1, 39, 1, colors.lime, colors.white)
    t:add("  Select Destination:", nil, 1, 2, 39, 2, colors.green, colors.white)

    t:add("Page: " .. page .. "/" .. pages, nil, 1, 3, 39, 3, colors.gray, colors.gray, colors.lime, colors.lime)

    for i = 1, 4 do
        local y = 1 + (i * 3)
        local color = colors.red
        local textColor = colors.white
        if i % 2 == 0 then
            color = colors.pink
            textColor = colors.black
        end
        local stationName = stations[i + ((page - 1) * 4)]
        if stationName then
            t:add("#" .. stationName, nil, 1, y, 39, y + 2, color, color, textColor, textColor)
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
                travel(button:gsub("#", ""))
                break
            end
            if button == "Next Page" then
                page = page + 1
                drawScreen(data)
                break
            end
            if button == "Previous Page" then
                page = page - 1
                drawScreen(data)
                break
            end
        end
    end
end

local function getStations()
    local request = {
        type = "station",
        ingoreId = data.id
    }
    local response = utils.httpPost("computer/list", request)
    stations = response.computers
    page = 1
    pages = math.ceil(utils.tablelength(stations) / 4)
end

local function stationMain()
    if not fs.exists(dataFile) then
        setup()
    end
    print("Reading station.json")
    data = json.decodeFromFile(dataFile)

    getStations()

    local ticketMachine = peripheral.find("ticket_machine")
    ticketMachine.setManualPrintingAllowed(false)

    drawScreen(data, stations)
end

while true do
    stationMain()
end