local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ratkinator/RatX/refs/heads/main/Games.lua"))()
local scriptUrl = Games[game.GameId]
if scriptUrl then
    loadstring(game:HttpGet(scriptUrl))()
    task.spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Ratkinator/RatX/refs/heads/main/Executed.lua"))() end)
else
    warn("❌ Unsupported game | GameId:", game.GameId)
end
return Games
