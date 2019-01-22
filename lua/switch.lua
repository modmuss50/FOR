os.loadAPI("utils.lua")

local dataFile = "switch.json"
local data = {}
local args = {...}
local bundled = "back"
local hold = true
local turn = false

local function getOtherSwitches()
    local request = {
        ingoreId = data.id
    }
    local response = utils.httpPost("computer/list", request)

    local names = {}
    for i = 1, utils.tablelength(response.computers) do
        table.insert(names, response.computers[i].name)
    end

    return names
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
    data.id =
        tonumber(utils.readValue("x pos")) ..
        "," .. tonumber(utils.readValue("y pos")) .. "," .. tonumber(utils.readValue("z pos"))
    wirteSwData()
end

local function updateConnections()
    local otherSwitches = getOtherSwitches()
    utils.messageTerm("Select next switch after stright on")
    data.contiunesTo = utils.list(otherSwitches, "Switch contiunes to:", true)
    utils.messageTerm("Select next switch after turn")
    data.turnsTo = utils.list(otherSwitches, "Switch turns to:", true)
    wirteSwData()
    utils.messageTerm("Switch data updated")
end

--Resets the system to be ready for the next train
local function updateRedstone()
    local color = colors.combine(colors.red, colors.green)
    if hold then
        color = colors.subtract(color, colors.red)
    end
    if not turn then
        color = colors.subtract(color, colors.green)
    end
    redstone.setBundledOutput(bundled, color)
end

local function resetSystem()
    hold = true
    turn = false
    updateRedstone()
end

local function shouldSwitch(train)
    local response = utils.httpPost("switch/request", data)
    print(response.status)
    if not response.status == "success" then
        error(response.status)
    end
    return response.shouldSwitch
end

local function onTrainPass(train)
    print(train.minecart.type)

    turn = shouldSwitch(train)
    hold = false
    updateRedstone()

    sleep(3) -- Allows time for whole train to pass

    hold = true
    turn = false
    updateRedstone()
end

local function waitForTrain()
    print("Waiting for train to pass")
    while true do
        local event, color, minecartType, minecartName, color1, color2, destination, ownerName =
            os.pullEvent("minecart")
        local passData = {
            info = data,
            minecart = {
                type = minecartType,
                name = minecartName,
                dest = destination,
                owner = ownerName
            }
        }

        onTrainPass(passData)
        break
    end
end

local function switching()
    if not fs.exists(dataFile) then
        setup()
    else
        data = json.decodeFromFile(dataFile)
    end

    if args[1] == "update" then
        updateConnections()
        print("connections updated")
        return
    end
    resetSystem()

    while true do
        waitForTrain()
    end
end

switching()
