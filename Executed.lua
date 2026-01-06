local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ratkinator/RatX/refs/heads/main/Games.lua"))()
local function getGameName(id)
    local url = Games[id]
    if not url then return "Universal Script" end
    local filename = url:match("([^/]+)%.lua$"):gsub("%%20", " ")
    return filename:gsub("%.lua$", ""):gsub("%.Lua$", "")
end
local HttpService = game:GetService("HttpService")
local success, response = pcall(function()
local gameName = getGameName(game.GameId)
local res = request({
Url = "https://halal-worker.vvladut245.workers.dev/",
Method = "POST",
Headers = {
["Content-Type"] = "application/json",
["GameName"] = gameName
},
Body = "{}"
})
return res and res.Body and HttpService:JSONDecode(res.Body)
end)
return (success and response and response.global_count) or "Unknown"
