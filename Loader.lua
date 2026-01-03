local Games = {
    [6161049307] = "https://raw.githubusercontent.com/Ratkinator/RatX/refs/heads/main/Pixel%20Blade.lua",
}
local scriptUrl = Games[game.GameId]
if scriptUrl then
    task.spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Ratkinator/RatX/refs/heads/main/Executed.lua"))() end)
    loadstring(game:HttpGet(scriptUrl))()
else
    warn("❌ Unsupported game | GameId:", game.GameId)
end
return Games
