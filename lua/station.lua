os.loadAPI("json.lua")
os.loadAPI("utils.lua")

local dataFile = "satation.json"

local function getStationID(stationData)
    print("Getting new ID from server for " .. stationData.name)
    local response = utils.post("station/new", stationData)
    print("New station id = ")
    return 0
end

local function setup()
    print("Station data not found, station setup tool:")
    print("Enter station name:")
    local name = read()
    print("Enter X pos:")
    local xPos = read()
    print("Enter Z pos:")
    local zPos = read()

    print("Is this correct? (y/n)")
    print("Station name: " .. name .. " X: " .. xPos .. "Y: " .. zPos)

    if not read() == "y" then
        exit()
    end

    local data = {
        name = name,
        x = xPos,
        z = zPos
    }

    local newId = getStationID(data)
    data.id = newId

    encodeToFile(dataFile, data)
end


local function stationMain()
    if not fs.exists(dataFile) then
        setup()
    end
    print("Reading station.json")
    data = decodeFromFile(dataFile)
    print("Hello " .. data.name)
end

stationMain()