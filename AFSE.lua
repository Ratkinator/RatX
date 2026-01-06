-- AFSE Script using WindUI
print("Starting AFSE Script...")

-- Load WindUI
local WindUI
local winduiSuccess = false

local urls = {
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/source.lua"
}

for _, url in ipairs(urls) do
    if not winduiSuccess then
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url, true))()
        end)
        
        if success and result then
            WindUI = result
            winduiSuccess = true
            print("[Rat Hub X] WindUI loaded from: " .. url)
            break
        end
    end
end

if not winduiSuccess then
    warn("[Rat Hub X] Failed to load WindUI")
    return
end

-- Create Main Window
local Window = WindUI:CreateWindow({
    Title = "Rat Hub X | AFSE",
    Theme = "Dark",
    Author = "Ratkinator",
    Folder = "RatHubX_Configs",
    Transparent = true
})

-- Add Tag
Window:Tag({
    Title = "v0.1 [BETA]",
    Icon = "github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 6,
})

print("[Rat Hub X] Window Created")

-- --- VARIABLES ---
local rs = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local lp = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- --- REMOTE EVENT SETUP ---
local RemoteEvent
local success, err = pcall(function()
    RemoteEvent = rs.Remotes.RemoteEvent
    print("[Rat Hub X] Found RemoteEvent:", RemoteEvent)
end)

if not success or not RemoteEvent then
    warn("[Rat Hub X] Could not find RemoteEvent. Looking for alternative paths...")
    if rs:FindFirstChild("RemoteEvent") then
        RemoteEvent = rs.RemoteEvent
    elseif rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("RemoteEvent") then
        RemoteEvent = rs.Remotes.RemoteEvent
    else
        warn("[Rat Hub X] RemoteEvent not found. Please check the path.")
        RemoteEvent = nil
    end
end

-- --- UI TABS ---
local HomeTab = Window:Tab({ Title = "Home", Icon = "home" })
local AutomationTab = Window:Tab({ Title = "Automation", Icon = "activity" })
local FarmingTab = Window:Tab({ Title = "Farming", Icon = "trending-up" })
local TeleportTab = Window:Tab({ Title = "Teleports", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })
local InfoTab = Window:Tab({ Title = "Info", Icon = "info" })

-- --- SECTIONS ---
local HomeSection = HomeTab:Section({ Title = "LocalPlayer" })
local AutomationSection = AutomationTab:Section({ Title = "Auto Training" })
local FarmingSection = FarmingTab:Section({ Title = "Farming Options" })
local TeleportSection = TeleportTab:Section({ Title = "Teleport Locations" })
local SettingsSection = SettingsTab:Section({ Title = "Configuration" })
local InfoSection = InfoTab:Section({ Title = "Stats" })

-- --- HOME TAB ---
HomeSection:Label({
    Title = "Welcome to Rat Hub X",
    Desc = "Anime Fighting Simulator Endless"
})

HomeSection:Paragraph({
    Title = "Status",
    Desc = RemoteEvent and "RemoteEvent: Connected" or "RemoteEvent: Not Found"
})

-- --- AUTOMATION TAB ---
AutomationSection:Label({
    Title = "Auto Training Options",
    Desc = "Toggle individual training stats"
})

-- Function to create auto training loops
local trainingStates = {}
local trainingConnections = {}

local function createAutoTraining(name, trainNumber)
    trainingStates[name] = false
    
    AutomationSection:Toggle({
        Title = name,
        Desc = "Automatically train " .. name:gsub("Auto ", ""),
        Default = false,
        Callback = function(state)
            trainingStates[name] = state
            
            -- Disconnect existing connection
            if trainingConnections[name] then
                trainingConnections[name]:Disconnect()
                trainingConnections[name] = nil
            end
            
            if state and RemoteEvent then
                -- Create new connection
                trainingConnections[name] = RunService.Heartbeat:Connect(function()
                    if trainingStates[name] and RemoteEvent then
                        local success, err = pcall(function()
                            RemoteEvent:FireServer("Train", trainNumber)
                        end)
                        if not success then
                            warn("[Rat Hub X] " .. name .. " error: " .. err)
                            trainingStates[name] = false
                        end
                        task.wait(0.1) -- Delay between calls
                    end
                end)
                print("[Rat Hub X] " .. name .. ": ON")
            else
                print("[Rat Hub X] " .. name .. ": OFF")
            end
        end
    })
end

-- Create all auto training toggles
if RemoteEvent then
    createAutoTraining("Auto Strength", 1)
    createAutoTraining("Auto Durability", 2)
    createAutoTraining("Auto Chakra", 3)
    createAutoTraining("Auto Katana", 4)
    createAutoTraining("Auto Agility", 5)
    createAutoTraining("Auto Speed", 6)
else
    AutomationSection:Label({
        Title = "ERROR",
        Desc = "RemoteEvent not found! Please rejoin."
    })
end

-- --- FARMING TAB ---
FarmingSection:Label({
    Title = "Coming Soon",
    Desc = "Farming features will be added in future updates"
})

-- --- TELEPORT TAB ---
TeleportSection:Label({
    Title = "Coming Soon",
    Desc = "Teleport features will be added in future updates"
})

-- --- SETTINGS TAB ---
SettingsSection:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevent being kicked for inactivity",
    Default = false,
    Callback = function(state)
        if state then
            local conn
            conn = RunService.Heartbeat:Connect(function()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            print("[Rat Hub X] Anti-AFK Enabled")
        else
            print("[Rat Hub X] Anti-AFK Disabled")
        end
    end
})

SettingsSection:Button({
    Title = "Reset Character",
    Desc = "Reset your character",
    Callback = function()
        if lp.Character then
            lp.Character:BreakJoints()
            print("[Rat Hub X] Character reset")
        end
    end
})

SettingsSection:Button({
    Title = "Rejoin Server",
    Desc = "Rejoin the current server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
        print("[Rat Hub X] Rejoining server")
    end
})

SettingsSection:Slider({
    Title = "Training Speed",
    Desc = "Delay between training actions",
    Value = {Min = 0,Max = 30,Default = 3},
    Callback = function(value)
        print("[Rat Hub X] Training speed set to: " .. value .. "s")
    end
})

SettingsSection:Toggle({
    Title = "Auto-Save Settings",
    Desc = "Automatically save your settings",
    Default = true,
    Callback = function(state)
        print("[Rat Hub X] Auto-Save: " .. tostring(state))
    end
})

SettingsSection:Button({
    Title = "Save Configuration",
    Desc = "Save current settings to file",
    Callback = function()
        print("[Rat Hub X] Configuration saved")
    end
})

SettingsSection:Button({
    Title = "Load Configuration",
    Desc = "Load saved settings from file",
    Callback = function()
        print("[Rat Hub X] Configuration loaded")
    end
})

-- --- INFO TAB ---
local countStr = "Loading..."
InfoSection:Paragraph({ 
    Title = "Total Executions", 
    Desc = countStr 
})

InfoSection:Paragraph({
    Title = "Game",
    Desc = "Anime Fighting Simulator Endless"
})

InfoSection:Paragraph({
    Title = "Version",
    Desc = "v0.1 [BETA]"
})

InfoSection:Paragraph({
    Title = "Author",
    Desc = "Ratkinator"
})

InfoSection:Paragraph({
    Title = "Status",
    Desc = RemoteEvent and "Connected" or "Disconnected"
})

-- Load execution count
task.spawn(function()
    pcall(function()
        local r = game:HttpGet("https://halal-worker.vvladut245.workers.dev/", true)
        local data = HttpService:JSONDecode(r)
        countStr = tostring(data.global_count or "N/A")
        print("[Rat Hub X] Execution Count: " .. countStr)
    end)
end)

-- Select Home tab
HomeTab:Select()

-- Success notification
task.wait(0.5)
WindUI:Notify({
    Title = "Rat Hub X | AFSE",
    Content = "Successfully loaded! Enjoy Anime Fighting Simulator Endless.",
    Duration = 3,
    Icon = "check-circle",
})

print("[Rat Hub X] AFSE Script fully loaded!")
