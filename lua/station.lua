os.loadAPI("json.lua")
os.loadAPI("utils.lua")

local dataFile = "satation.json"

local function getStationID(stationData)
    print("Getting new ID from server for " .. stationData.name)
    local response = utils.post("station/new", stationData)
    print("New station id = ")
    return 0
end

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

    local newId = getStationID(data)
    data.id = newId

    json.encodeToFile(dataFile, data)
end

local function stationMain()
    if not fs.exists(dataFile) then
        setup()
    end
    print("Reading station.json")
    data = json.decodeFromFile(dataFile)
    print("Hello " .. data.name)
end

stationMain()
