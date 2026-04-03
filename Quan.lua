-- LOAD GAME
repeat task.wait() until game:IsLoaded()
task.wait(1)

local player = game.Players.LocalPlayer

------------------------------------------------------------
-- LOAD FLUENT
local Fluent = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/dawid-scripts/Fluent/main/main.lua"
))()

------------------------------------------------------------
-- WINDOW
local Window = Fluent:CreateWindow({
    Title = "Grai Hub Mobile",
    Size = UDim2.fromOffset(350,250),
    Theme = "Dark"
})

Window:Toggle() -- ⚠️ BẮT BUỘC

------------------------------------------------------------
-- TAB
local Tabs = {
    Main = Window:AddTab({Title="Script"})
}

------------------------------------------------------------
-- SCRIPT
Tabs.Main:AddButton({
    Title="Fix Lag",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()
    end
})

Tabs.Main:AddButton({
    Title="Anti AFK",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/uubinok1222/Anti-afk/main/By%20chatgpt"))()
    end
})

------------------------------------------------------------
-- NÚT MENU TO (DỄ BẤM)
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Parent = gui
btn.Size = UDim2.new(0,80,0,80) -- to hơn
btn.Position = UDim2.new(0.75,0,0.6,0)
btn.Text = "MENU"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.fromRGB(0,255,255)

Instance.new("UICorner", btn)

-- bật/tắt menu
btn.MouseButton1Click:Connect(function()
    pcall(function()
        Window:Toggle()
    end)
end)
