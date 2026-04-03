local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- 🌌 INTRO GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GraiIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
bg.BackgroundTransparency = 0.3
bg.Parent = gui

local logo = Instance.new("ImageLabel")
logo.Parent = gui
logo.AnchorPoint = Vector2.new(0.5,0.5)
logo.Position = UDim2.new(0.5,0,0.5,0)
logo.Size = UDim2.new(0,0,0,0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://77111304194141"
logo.ImageTransparency = 1

TweenService:Create(logo, TweenInfo.new(1.5, Enum.EasingStyle.Elastic), {
    Size = UDim2.new(0,200,0,200),
    ImageTransparency = 0
}):Play()

task.spawn(function()
    while logo.Parent do
        logo.Rotation += 0.5
        task.wait(0.01)
    end
end)

local msg = Instance.new("TextLabel")
msg.Parent = gui
msg.AnchorPoint = Vector2.new(0.5,0)
msg.Position = UDim2.new(0.5,0,0.75,0)
msg.Size = UDim2.new(0,600,0,80)
msg.BackgroundTransparency = 1
msg.Text = "Grai Hub"
msg.TextColor3 = Color3.fromRGB(0,255,255)
msg.Font = Enum.Font.GothamBlack
msg.TextScaled = true
msg.TextStrokeTransparency = 0
msg.TextTransparency = 1

TweenService:Create(msg, TweenInfo.new(1.2), {TextTransparency=0}):Play()

task.wait(4)

TweenService:Create(logo, TweenInfo.new(1), {ImageTransparency=1}):Play()
TweenService:Create(msg, TweenInfo.new(1), {TextTransparency=1}):Play()
TweenService:Create(bg, TweenInfo.new(1), {BackgroundTransparency=1}):Play()
task.wait(1)

gui:Destroy()

------------------------------------------------------------
-- 🎛 MAIN BUTTON
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("ImageButton")
btn.Parent = ScreenGui
btn.Size = UDim2.new(0,40,0,40)
btn.Position = UDim2.new(0.1,0,0.15,0)
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.Image = "rbxassetid://77111304194141"
btn.Draggable = true

Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

btn.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.End,false,game)
end)

------------------------------------------------------------
-- 📦 LOAD UI
repeat task.wait() until game:IsLoaded()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title="ff+",
    SubTitle="Tổng Hợp Script",
    Size=UDim2.fromOffset(450,300),
    Theme="Dark",
    MinimizeKey=Enum.KeyCode.End
})

-- Tabs
local Tabs = {
    Info = Window:AddTab({Title="Thông Tin"}),
    BF = Window:AddTab({Title="Blox Fruits"}),
    Other = Window:AddTab({Title="Khác"})
}

-- INFO
Tabs.Info:AddButton({
    Title="Copy Youtube",
    Callback=function()
        setclipboard("https://youtube.com/@grai2")
    end
})

-- BLOX FRUITS
Tabs.BF:AddButton({
    Title="Redz Hub",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/main/Source.luau"))()
    end
})

Tabs.BF:AddButton({
    Title="Fix Lag",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()
    end
})

Tabs.BF:AddButton({
    Title="Min Hub",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Min/main/MinXt2Eng"))()
    end
})

-- TAB KHÁC
Tabs.Other:AddButton({
    Title="Anti AFK",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/uubinok1222/Anti-afk/main/By%20chatgpt"))()
    end
})

Tabs.Other:AddButton({
    Title="Speed Hub X",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"))()
    end
})
