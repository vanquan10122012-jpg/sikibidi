-- CHỜ GAME LOAD
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
task.wait(2)

local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "Quan2012Hub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,280)
main.Position = UDim2.new(0.5,-130,0.5,-140)
main.BackgroundColor3 = Color3.fromRGB(15,15,35)
main.Active = true
Instance.new("UICorner", main)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(0.6,0,0,40)
title.Position = UDim2.new(0.05,0,0,0)
title.Text = "Quân2012"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,255)

-- NÚT X
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,28,0,24)
close.Position = UDim2.new(1,-32,0,4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(60,0,0)
close.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", close)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- BUTTON FUNCTION
local function btn(txt,y,callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.85,0,0,40)
    b.Position = UDim2.new(0.075,0,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextColor3 = Color3.fromRGB(0,255,255)
    b.TextScaled = true
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

-- BUTTONS (KHÔNG AUTO)
btn("Fix Lag",80,function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()
end)

btn("Anti AFK",130,function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/uubinok1222/Anti-afk/refs/heads/main/By%20chatgpt"))()
end)

btn("Speed Hub X",180,function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"))()
end)

-- MENU NGOÀI
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,45,0,45)
toggle.Position = UDim2.new(0.85,0,0.7,0)
toggle.Text = "≡"
toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggle.TextColor3 = Color3.fromRGB(0,255,255)
toggle.TextScaled = true
Instance.new("UICorner", toggle)

local open = true
toggle.MouseButton1Click:Connect(function()
    open = not open
    main.Visible = open
end)

-- DRAG MOBILE
local UIS = game:GetService("UserInputService")

local function drag(frame)
    local dragging = false
    local startPos, startFrame

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startFrame = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(
                startFrame.X.Scale,
                startFrame.X.Offset + delta.X,
                startFrame.Y.Scale,
                startFrame.Y.Offset + delta.Y
            )
        end
    end)
end

drag(main)
drag(toggle)
