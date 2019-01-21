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
    data.id = data.pos.x .. "," .. data.pos.y .. "," .. data.pos.z

    json.encodeToFile(dataFile, data)
end

local function dectectorMain()
    if not fs.exists(dataFile) then
        setup()
    end
    print("Reading " .. dataFile)
    local data = json.decodeFromFile(dataFile)

    while true do
        local event, color, minecartType, minecartName, color1, color2, destination, ownerName = os.pullEvent("minecart")
        local passData = {
            info = data,
            minecart = {
                type = minecartType,
                name = minecartName,
                dest = destination,
                owner = ownerName
            }
        }
        print(json.encodePretty(passData))
        utils.httpPostAsync("detector/pass", passData)
    end
end

dectectorMain()
