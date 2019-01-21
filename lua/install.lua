local baseURL = "https://raw.githubusercontent.com/modmuss50/FOR/master/lua/"

print("Downloading file list")

local response = http.get(baseURL .. "files.txt")

local body = response.readAll()
local lines = {}

for s in body:gmatch("[^\r\n]+") do
    table.insert(lines, s)
end

for i = 1, #lines do
    local filename = lines[i]
    print("Downloading: " .. filename)
    if fs.exists(filename) then
        fs.delete(filename)
    end
    local url = baseURL .. filename
    shell.run("wget", url, filename)
end

print("Done, downloaded " .. table.getn(lines) .. " files")
