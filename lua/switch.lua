os.loadAPI("utils.lua")

local dataFile = "switch.json"
local data = {}
local args = {...}

local function getOtherSwitches()
    local request = {
        ingoreId = data.id
    }
    local response = utils.httpPost("computer/list", request)
    return response.computers
end

local function wirteSwData()
    local response = utils.httpPost("switch/new", data)
    if not response.status == "success" then
        error(response.status)
    end

    json.encodeToFile(dataFile, data)
end


local function setup()
    print("Enter switch data:")
    data = {
        name = utils.readValue("switch name")
    }
    data.id = tonumber(utils.readValue("x pos")) .. "," .. tonumber(utils.readValue("y pos")) .. "," .. tonumber(utils.readValue("z pos"))
    wirteSwData()
end

local function updateConnections()
    local otherSwitches = getOtherSwitches()
    utils.message("Select next switch after stright on")
    data.contiunesTo = utils.list(otherSwitches, "Switch contiunes to:", true)
    utils.message("Select next switch after turn")
    data.turnsTo = utils.list(otherSwitches, "Switch turns to:", true)
    wirteSwData()
    utils.message("Switch data updated")
end

local function switching()
    if not fs.exists(dataFile) then
        setup()
    else
        data = json.decodeFromFile(dataFile)
    end

    if args[1] == "update" then
        updateConnections()
    end
end

switching()
