local baseURL = "https://raw.githubusercontent.com/modmuss50/FOR/master/lua/"

print("Downloading file list")

local response = http.get(baseURL .. "files.txt".. getUrlSuffix())

local body = response.readAll()
local lines = {}

for s in body:gmatch("[^\r\n]+") do
    table.insert(lines, s)
end

for i = 1, #lines do
    local filename = lines[i]
    print("Downloading: " .. filename)
    if fs.exists(filename) then
        print("Deleting old " .. filename)
        fs.delete(filename)
    end

    local url = baseURL .. filename .. getUrlSuffix()
    local fileBody = http.get(url).readAll()
    local file = assert(fs.open(filename, "w"))
    file.write(fileBody)
    file.close()
end

print("Done, downloaded " .. table.getn(lines) .. " files")

--Gets around caching
local function getUrlSuffix()
    return "?t=" .. math.random(1, 10000)
end