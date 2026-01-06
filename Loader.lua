local Games = {
    [6161049307] = "https://raw.githubusercontent.com/Ratkinator/RatX/refs/heads/main/Pixel%20Blade.lua",
    [9266873836] = "https://raw.githubusercontent.com/Ratkinator/RatX/refs/heads/main/AFSE.lua",
}
local scriptUrl = Games[game.GameId]
if scriptUrl then
    loadstring(game:HttpGet(scriptUrl))()
    Tracker = game:HttpGet("https://raw.githubusercontent.com/Ratkinator/RatX/refs/heads/main/Executed.lua")
    local Run = loadstring(Tracker)
    task.spawn(function() Run(Games) end)
else
    warn("❌ Unsupported game | GameId:", game.GameId)
end
return Games
