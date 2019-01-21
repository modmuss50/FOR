os.loadAPI("json.lua")
os.loadAPI("utils.lua")

local dataFile = "detector.json"

local function readValue(name)
    print("Enter " .. name .. ":")
    return read()
end

local function setup()
    print("Detector data not found, station setup tool:")
    local data = {
        pos = {
            x = readValue("x pos"),
            y = readValue("y pos"),
            z = readValue("z pos")
        }
    }
    data.id = x .. "," .. y .. "," .. z

    json.encodeToFile(dataFile, data)
end

local function dectectorMain()
    if not fs.exists(dataFile) then
        setup()
    end
    print("Reading " .. dataFile)
    local data = json.decodeFromFile(dataFile)

    while true do
        local event, minecartType, minecartName, primaryColor, secondaryColor, destination, ownerName = os.pullEvent("minecart")
        local data = {
            type = minecartType,
            name = minecartName,
            color = primaryColor,
            color2 = secondaryColor,
            dest = destination,
            owner = ownerName
        }
        utils.post("detector/pass", data)
    end
end

dectectorMain()
