repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local RS = game:GetService("ReplicatedStorage")

-- REMOTE SKILL
local RequestAbility = RS.AbilitySystem.Remotes.RequestAbility

-- Z=1, X=2, C=3, V=4, F=5
local slotMap = {Z=1, X=2, C=3, V=4, F=5}

-- DATA
local file = "BananaLite_SailorPiece.json"

local data = {
    States = {},
    Weapon = "",
    Farm = nil,
    Skill = {Z=false, X=false, C=false, V=false, F=false},
    SkillDelay = 1.5
}

_G.Running = _G.Running or {}

if isfile and isfile(file) then
    local success, decoded = pcall(function()
        return HttpService:JSONDecode(readfile(file))
    end)
    if success then data = decoded end
end

local function save()
    if writefile then
        writefile(file, HttpService:JSONEncode(data))
    end
end

local function root()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    return player.Character and player.Character:FindFirstChildOfClass("Humanoid")
end

local function isAlive()
    local hum = getHum()
    return hum and hum.Health > 0
end

-- AUTO SKILL LOOP
local skillUsing = false
task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if not isAlive() or skillUsing then return end

            for _, key in pairs({"Z","X","C","V","F"}) do
                if data.Skill[key] then
                    skillUsing = true

                    pcall(function()
                        RequestAbility:FireServer(slotMap[key])
                    end)

                    task.wait(data.SkillDelay)
                    skillUsing = false
                end
            end
        end)
    end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

local mini = Instance.new("ImageButton")
mini.Parent = gui
mini.Size = UDim2.new(0,45,0,45)
mini.Position = UDim2.new(0.02,0,0.3,0)
mini.BackgroundTransparency = 1
mini.Image = "rbxassetid://113151661733524"
Instance.new("UICorner", mini)

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,650,0,420)
main.Position = UDim2.new(0.5,-325,0.5,-210)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.Visible = false
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Color = Color3.fromRGB(255,200,0)
stroke.Thickness = 1.5

mini.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- DRAG
local function drag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

drag(main)
drag(mini)

-- LEFT MENU
local left = Instance.new("Frame")
left.Parent = main
left.Size = UDim2.new(0,150,1,-35)
left.Position = UDim2.new(0,0,0,35)
left.BackgroundColor3 = Color3.fromRGB(25,25,30)

local leftLayout = Instance.new("UIListLayout")
leftLayout.Parent = left
leftLayout.Padding = UDim.new(0,5)

-- RIGHT
local right = Instance.new("ScrollingFrame")
right.Parent = main
right.Size = UDim2.new(1,-160,1,-35)
right.Position = UDim2.new(0,160,0,35)
right.BackgroundTransparency = 1
right.AutomaticCanvasSize = Enum.AutomaticSize.Y
right.ScrollBarThickness = 4

local rightLayout = Instance.new("UIListLayout")
rightLayout.Parent = right
rightLayout.Padding = UDim.new(0,6)

local function clear()
    for _,v in pairs(right:GetChildren()) do
        if not v:IsA("UIListLayout") then v:Destroy() end
    end
end

-- TOGGLE
local function toggle(name, func)
    data.States[name] = data.States[name] or false

    local frame = Instance.new("Frame")
    frame.Parent = right
    frame.Size = UDim2.new(1,-10,0,35)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
    Instance.new("UICorner", frame)

    local text = Instance.new("TextLabel")
    text.Parent = frame
    text.Size = UDim2.new(1,-40,1,0)
    text.Position = UDim2.new(0,10,0,0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.TextColor3 = Color3.new(1,1,1)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0,20,0,20)
    btn.Position = UDim2.new(1,-30,0.5,-10)
    Instance.new("UICorner", btn)

    local function updateUI()
        btn.BackgroundColor3 = data.States[name]
            and Color3.fromRGB(255,200,0)
            or Color3.fromRGB(60,60,60)
    end
    updateUI()

    if data.States[name] and not _G.Running[name] then
        _G.Running[name] = true
        task.spawn(func)
    end

    btn.MouseButton1Click:Connect(function()
        data.States[name] = not data.States[name]
        updateUI()
        save()
        if data.States[name] and not _G.Running[name] then
            _G.Running[name] = true
            task.spawn(func)
        elseif not data.States[name] then
            _G.Running[name] = false
        end
    end)
end

-- MAIN TAB
local function MainTab()
    toggle("Quantum Hub", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/main/QuantumOnyx.lua"))()
    end)
    toggle("Lọ Vương Hub", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/anuragaming1/anura/main/soclo.lua"))()
    end)
    toggle("Chiyo Hub", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kaisenlmao/loader/main/chiyo.lua"))()
    end)
end

-- FARM TAB
local function FarmTab()
    local wLabel = Instance.new("TextLabel")
    wLabel.Parent = right
    wLabel.Size = UDim2.new(1,0,0,25)
    wLabel.BackgroundTransparency = 1
    wLabel.TextColor3 = Color3.new(1,1,1)
    wLabel.Font = Enum.Font.Gotham
    wLabel.Text = "Weapon : "..(data.Weapon == "" and "NONE" or data.Weapon)

    local set = Instance.new("TextButton")
    set.Parent = right
    set.Size = UDim2.new(1,0,0,30)
    set.Text = "SET WEAPON & FARM POS"
    set.BackgroundColor3 = Color3.fromRGB(45,45,50)
    set.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", set)

    set.MouseButton1Click:Connect(function()
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            data.Weapon = tool.Name
            wLabel.Text = "Weapon : "..tool.Name
        end
        if root() then data.Farm = root().CFrame end
        save()
    end)

    local reset = Instance.new("TextButton")
    reset.Parent = right
    reset.Size = UDim2.new(1,0,0,30)
    reset.Text = "RESET ALL FARM DATA"
    reset.BackgroundColor3 = Color3.fromRGB(120,30,30)
    reset.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", reset)

    reset.MouseButton1Click:Connect(function()
        data.Weapon = ""
        data.Farm = nil
        wLabel.Text = "Weapon : NONE"
        save()
    end)

    toggle("Auto Equip", function()
        while data.States["Auto Equip"] do
            pcall(function()
                if data.Weapon ~= "" then
                    local tool = player.Backpack:FindFirstChild(data.Weapon)
                    if tool then player.Character.Humanoid:EquipTool(tool) end
                end
            end)
            task.wait(0.5)
        end
        _G.Running["Auto Equip"] = false
    end)

    toggle("Teleport Farm", function()
        while data.States["Teleport Farm"] do
            pcall(function()
                if data.Farm and root() then root().CFrame = data.Farm end
            end)
            task.wait(0.1)
        end
        _G.Running["Teleport Farm"] = false
    end)
end

-- SKILL TAB
local function SkillTab()

    local delayLabel = Instance.new("TextLabel")
    delayLabel.Parent = right
    delayLabel.Size = UDim2.new(1,0,0,25)
    delayLabel.BackgroundTransparency = 1
    delayLabel.TextColor3 = Color3.fromRGB(255,200,0)
    delayLabel.Font = Enum.Font.GothamBold
    delayLabel.Text = "Skill Delay : "..tostring(data.SkillDelay).."s"
    delayLabel.TextXAlignment = Enum.TextXAlignment.Left

    local row = Instance.new("Frame")
    row.Parent = right
    row.Size = UDim2.new(1,0,0,30)
    row.BackgroundTransparency = 1

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.Parent = row
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0,6)

    local delayDown = Instance.new("TextButton")
    delayDown.Parent = row
    delayDown.Size = UDim2.new(0.48,0,1,0)
    delayDown.Text = "- Delay"
    delayDown.BackgroundColor3 = Color3.fromRGB(50,50,60)
    delayDown.TextColor3 = Color3.new(1,1,1)
    delayDown.Font = Enum.Font.GothamBold
    Instance.new("UICorner", delayDown)

    local delayUp = Instance.new("TextButton")
    delayUp.Parent = row
    delayUp.Size = UDim2.new(0.48,0,1,0)
    delayUp.Text = "+ Delay"
    delayUp.BackgroundColor3 = Color3.fromRGB(50,50,60)
    delayUp.TextColor3 = Color3.new(1,1,1)
    delayUp.Font = Enum.Font.GothamBold
    Instance.new("UICorner", delayUp)

    delayUp.MouseButton1Click:Connect(function()
        data.SkillDelay = math.min(math.floor((data.SkillDelay+0.1)*10+0.5)/10, 5)
        delayLabel.Text = "Skill Delay : "..tostring(data.SkillDelay).."s"
        save()
    end)

    delayDown.MouseButton1Click:Connect(function()
        data.SkillDelay = math.max(math.floor((data.SkillDelay-0.1)*10+0.5)/10, 0.3)
        delayLabel.Text = "Skill Delay : "..tostring(data.SkillDelay).."s"
        save()
    end)

    for _, k in pairs({"Z","X","C","V","F"}) do
        local b = Instance.new("TextButton")
        b.Parent = right
        b.Size = UDim2.new(1,0,0,35)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 16
        Instance.new("UICorner", b)

        local function update()
            if data.Skill[k] then
                b.Text = "[ "..k.." ]  ON  ✓"
                b.BackgroundColor3 = Color3.fromRGB(255,200,0)
                b.TextColor3 = Color3.fromRGB(20,20,20)
            else
                b.Text = "[ "..k.." ]  OFF"
                b.BackgroundColor3 = Color3.fromRGB(40,40,45)
                b.TextColor3 = Color3.new(1,1,1)
            end
        end
        update()

        b.MouseButton1Click:Connect(function()
            data.Skill[k] = not data.Skill[k]
            update()
            save()
        end)
    end
end

-- SETTING TAB
local function SettingTab()
    toggle("Fix Lag + FPS", function()
        if setfpscap then setfpscap(120) end
        while data.States["Fix Lag + FPS"] do
            settings().Rendering.QualityLevel = 1
            game:GetService("Lighting").GlobalShadows = false
            for _,v in pairs(game:GetDescendants()) do
                pcall(function()
                    if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                        v.Material = Enum.Material.Plastic
                        v.Reflectance = 0
                    elseif v:IsA("Texture") or v:IsA("Decal") then
                        v:Destroy()
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                        v.Enabled = false
                    end
                end)
            end
            task.wait(10)
        end
        _G.Running["Fix Lag + FPS"] = false
    end)

    toggle("Anti AFK", function()
        player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

-- CODE TAB
local function CodeTab()
    local title = Instance.new("TextLabel")
    title.Parent = right
    title.Size = UDim2.new(1,0,0,30)
    title.BackgroundTransparency = 1
    title.Text = "CODES"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20

    local function createGameCodes(gameName, codes)
        local frame = Instance.new("Frame")
        frame.Parent = right
        frame.Size = UDim2.new(1,-5,0,(#codes*32)+50)
        frame.BackgroundColor3 = Color3.fromRGB(35,35,40)
        Instance.new("UICorner", frame)

        local titleGame = Instance.new("TextLabel")
        titleGame.Parent = frame
        titleGame.Size = UDim2.new(1,0,0,25)
        titleGame.Position = UDim2.new(0,10,0,5)
        titleGame.BackgroundTransparency = 1
        titleGame.Text = gameName
        titleGame.TextColor3 = Color3.fromRGB(255,200,0)
        titleGame.Font = Enum.Font.GothamBold
        titleGame.TextSize = 18
        titleGame.TextXAlignment = Enum.TextXAlignment.Left

        local y = 35
        for _,code in pairs(codes) do
            local codeBtn = Instance.new("TextButton")
            codeBtn.Parent = frame
            codeBtn.Size = UDim2.new(1,-20,0,22)
            codeBtn.Position = UDim2.new(0,10,0,y)
            codeBtn.BackgroundTransparency = 1
            codeBtn.Text = code
            codeBtn.TextColor3 = Color3.new(1,1,1)
            codeBtn.Font = Enum.Font.Gotham
            codeBtn.TextSize = 14
            codeBtn.TextXAlignment = Enum.TextXAlignment.Left
            codeBtn.MouseButton1Click:Connect(function()
                if setclipboard then setclipboard(code) end
                codeBtn.Text = code.."  ✓ COPIED"
                task.wait(1.5)
                codeBtn.Text = code
            end)
            y = y + 32
        end
    end

    createGameCodes("Code Slime RNG", {"giveMeLuckNOW","test","gullible"})
    createGameCodes("Code Sailor Piece", {
        "TYSMFOR400KFOLLOWONEVENT","1M100KLIKESTYYY",
        "1B300MVISITS","1B200MVISITS","1B100MVISITS",
        "DELAYCODENR2","DELAYCODENR1","RAIDS","HUGEUPDATEWWW"
    })
end

-- TAB BUTTON
local function tab(name, func)
    local b = Instance.new("TextButton")
    b.Parent = left
    b.Size = UDim2.new(1,0,0,35)
    b.BackgroundTransparency = 1
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.Text = name
    b.MouseButton1Click:Connect(function()
        clear()
        func()
    end)
end

tab("Main", MainTab)
tab("Farm", FarmTab)
tab("Skills", SkillTab)
tab("Setting", SettingTab)
tab("Code", CodeTab)

clear()
MainTab()
