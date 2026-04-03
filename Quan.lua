local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

------------------------------------------------------------
-- 🌌 INTRO
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame", gui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
bg.BackgroundTransparency = 0.3

local logo = Instance.new("ImageLabel", gui)
logo.AnchorPoint = Vector2.new(0.5,0.5)
logo.Position = UDim2.new(0.5,0,0.5,0)
logo.Size = UDim2.new(0,0,0,0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://77111304194141"
logo.ImageTransparency = 1

TweenService:Create(logo, TweenInfo.new(1), {
    Size = UDim2.new(0,180,0,180),
    ImageTransparency = 0
}):Play()

task.wait(2)
gui:Destroy()

------------------------------------------------------------
-- 📦 LOAD FLUENT
repeat task.wait() until game:IsLoaded()

local Fluent = loadstring(game:HttpGet(
"https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
))()

local Window = Fluent:CreateWindow({
    Title = "Grai Hub",
    Size = UDim2.fromOffset(420,280),
    Theme = "Dark"
})

------------------------------------------------------------
-- 📑 TABS
local Tabs = {
    Info = Window:AddTab({Title="Thông Tin"}),
    Main = Window:AddTab({Title="Script"}),
}

------------------------------------------------------------
-- 🔘 BUTTON MỞ MENU (FIX HOÀN TOÀN)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local btn = Instance.new("TextButton", ScreenGui)
btn.Size = UDim2.new(0,50,0,50)
btn.Position = UDim2.new(0.5,-25,0.5,-25)
btn.Text = "MENU"
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.fromRGB(0,255,255)
btn.Draggable = true

Instance.new("UICorner", btn)

local opened = true
btn.MouseButton1Click:Connect(function()
    opened = not opened
    Window:Toggle()
end)

------------------------------------------------------------
-- 📌 INFO
Tabs.Info:AddButton({
    Title = "Copy Youtube",
    Callback = function()
        setclipboard("https://youtube.com/@grai2")
    end
})

------------------------------------------------------------
-- ⚔️ SCRIPT
Tabs.Main:AddButton({
    Title="Redz Hub",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/main/Source.luau"))()
    end
})

Tabs.Main:AddButton({
    Title="Fix Lag",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()
    end
})

Tabs.Main:AddButton({
    Title="Speed Hub X",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"))()
    end
})

Tabs.Main:AddButton({
    Title="Anti AFK",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/uubinok1222/Anti-afk/main/By%20chatgpt"))()
    end
})
