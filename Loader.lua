local Games = {
    [6161049307] = "https://github.com/Ratkinator/RatX/blob/main/Pixel%20Blade.lua",
    [9876543210] = "https://raw.githubusercontent.com/USER/REPO/main/game2.lua"
}

local scriptUrl = Games[game.GameId]

if scriptUrl then
    loadstring(game:HttpGet(scriptUrl))()
else
    warn("❌ Unsupported game | GameId:", game.GameId)
end
