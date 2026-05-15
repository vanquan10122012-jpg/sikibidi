-- [[ BANANA LITE - UNIVERSAL EDITION ]] --
-- Đã tối ưu hóa chống Lag và chạy được trên mọi Game
repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- [ DỮ LIỆU CÀI ĐẶT ]
local file = "BananaLite_Universal.json"
local data = {
    States = {},
    Weapon = "",
    Farm = nil,
    Skill = {Z=false, X=false, C=false, V=false, F=false},
    SkillDelay = 1.0
}

_G.Running = _G.Running or {}

-- Tải dữ liệu cũ nếu có
if isfile and isfile(file) then
    pcall(function() data = HttpService:JSONDecode(readfile(file)) end)
end

local function save()
    if writefile then writefile(file, HttpService:JSONEncode(data)) end
end

-- [ CÁC HÀM TIỆN ÍCH ]
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

-- [ VÒNG LẶP SKILL (UNIVERSAL - MỌI GAME) ]
local skillUsing = false
task.spawn(function()
    while task.wait(0.1) do
        if not isAlive() or skillUsing then continue end

        for _, key in pairs({"Z","X","C","V","F"}) do
            if data.Skill[key] then
                skillUsing = true
                pcall(function()
                    -- Giả lập bấm phím vật lý (chạy được trên 99% game)
                    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                    task.wait(0.05)
                    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                end)
                task.wait(data.SkillDelay)
                skillUsing = false
            end
        end
    end
end)

-- [ GIAO DIỆN CHÍNH (GUI) ]
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "BananaLiteUniversal"
gui.ResetOnSpawn = false

-- Nút mở menu mini
local mini = Instance.new("ImageButton", gui)
mini.Size = UDim2.new(0, 45, 0, 45)
mini.Position = UDim2.new(0.02, 0, 0.3, 0)
mini.BackgroundTransparency = 1
mini.Image = "rbxassetid://113151661733524"
Instance.new("UICorner", mini)

-- Khung Main
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 650, 0, 400)
main.Position = UDim2.new(0.5, -325, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Visible = false
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 200, 0)
stroke.Thickness = 1.5

mini.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- Kéo thả mượt mà
local function dragify(Frame)

    local dragToggle = false
    local dragInput
    local dragStart
    local startPos

    local function updateInput(input)

        local Delta = input.Position - dragStart

        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + Delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + Delta.Y
        )
    end

    Frame.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()

                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end

            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

            dragInput = input

        end
    end)

    UIS.InputChanged:Connect(function(input)

        if input == dragInput and dragToggle then
            updateInput(input)
        end

    end)
end
dragify(main)
dragify(mini)

-- Layout Trái / Phải
local left = Instance.new("Frame", main); left.Size = UDim2.new(0, 140, 1, -20); left.Position = UDim2.new(0, 10, 0, 10); left.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", left)
Instance.new("UIListLayout", left).Padding = UDim.new(0, 5)

local right = Instance.new("ScrollingFrame", main)
right.Size = UDim2.new(1, -165, 1, -20)
right.Position = UDim2.new(0, 155, 0, 10)
right.BackgroundTransparency = 1
right.ScrollBarThickness = 3
right.CanvasSize = UDim2.new(0,0,5,0)
right.AutomaticCanvasSize = Enum.AutomaticSize.Y
right.ScrollingDirection = Enum.ScrollingDirection.Y
right.BorderSizePixel = 0

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = right

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    right.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

local function clear()
    for _, v in pairs(right:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end
end

-- Hàm tạo Toggles chuẩn hóa
local function toggle(name, func)
    data.States[name] = data.States[name] or false
    local frame = Instance.new("Frame", right); frame.Size = UDim2.new(1, -10, 0, 35); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", frame)
    local text = Instance.new("TextLabel", frame); text.Size = UDim2.new(1, -50, 1, 0); text.Position = UDim2.new(0, 10, 0, 0); text.Text = name; text.TextColor3 = Color3.new(1,1,1); text.Font = Enum.Font.Gotham; text.TextXAlignment = "Left"; text.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 25, 0, 25); btn.Position = UDim2.new(1, -35, 0.5, -12); btn.Text = ""; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local function updateUI()
        btn.BackgroundColor3 = data.States[name] and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(60, 60, 65)
    end
    updateUI()

    if data.States[name] and not _G.Running[name] then
        _G.Running[name] = true; task.spawn(func)
    end

    btn.MouseButton1Click:Connect(function()
        data.States[name] = not data.States[name]; updateUI(); save()
        if data.States[name] then _G.Running[name] = true; task.spawn(func) else _G.Running[name] = false end
    end)
end

-- [ TẠO CÁC TABS ]

-- 1. TAB MAIN (Hubs)
local function MainTab()
    toggle("Quantum Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/main/QuantumOnyx.lua"))() data.States["Quantum Hub"] = false end)
    toggle("Lọ Vương Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/anuragaming1/anura/main/soclo.lua"))() data.States["Lọ Vương Hub"] = false end)
    toggle("Chiyo Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kaisenlmao/loader/main/chiyo.lua"))() data.States["Chiyo Hub"] = false end)
end

-- 2. TAB FARM
local function FarmTab()
    local wLabel = Instance.new("TextLabel", right); wLabel.Size = UDim2.new(1,0,0,25); wLabel.Text = "Weapon : "..(data.Weapon == "" and "NONE" or data.Weapon); wLabel.TextColor3 = Color3.new(1,1,1); wLabel.BackgroundTransparency = 1; wLabel.Font = Enum.Font.Gotham
    local setBtn = Instance.new("TextButton", right); setBtn.Size = UDim2.new(1,-10,0,30); setBtn.Text = "LƯU VŨ KHÍ & VỊ TRÍ"; setBtn.BackgroundColor3 = Color3.fromRGB(45,45,50); setBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", setBtn)
    
    setBtn.MouseButton1Click:Connect(function()
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then data.Weapon = tool.Name; wLabel.Text = "Weapon : "..tool.Name end
        if root() then data.Farm = root().CFrame end; save()
    end)

    toggle("Tự động cầm Vũ khí (Auto Equip)", function()
        while data.States["Tự động cầm Vũ khí (Auto Equip)"] do
            pcall(function()
                if data.Weapon ~= "" then
                    local tool = player.Backpack:FindFirstChild(data.Weapon)
                    if tool then getHum():EquipTool(tool) end
                end
            end)
            task.wait(0.5)
        end
    end)
 local resetBtn = Instance.new("TextButton", right)
resetBtn.Size = UDim2.new(1,-10,0,30)
resetBtn.Text = "RESET FARM"
resetBtn.BackgroundColor3 = Color3.fromRGB(120,35,35)
resetBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", resetBtn)

resetBtn.MouseButton1Click:Connect(function()

    data.Weapon = ""
    data.Farm = nil

    save()

    wLabel.Text = "Weapon : NONE"

end)

    toggle("Teleport tới điểm Farm", function()
        while data.States["Teleport tới điểm Farm"] do
            pcall(function() if data.Farm and root() then root().CFrame = data.Farm end end)
            task.wait(0.1)
        end
    end)
    
    toggle("Auto Click Chuột Trái", function()
        while data.States["Auto Click Chuột Trái"] do
            VirtualUser:ClickButton1(Vector2.new())
            task.wait(0.1)
        end
    end)
end

-- 3. TAB SKILLS
local function SkillTab()
    local delayLabel = Instance.new("TextLabel", right); delayLabel.Size = UDim2.new(1,0,0,25); delayLabel.Text = "Độ trễ Skill: "..data.SkillDelay.."s"; delayLabel.TextColor3 = Color3.fromRGB(255,200,0); delayLabel.Font = Enum.Font.GothamBold; delayLabel.BackgroundTransparency = 1
    
    local row = Instance.new("Frame", right); row.Size = UDim2.new(1,-10,0,30); row.BackgroundTransparency = 1
    local btnDown = Instance.new("TextButton", row); btnDown.Size = UDim2.new(0.48,0,1,0); btnDown.Text = "- Giảm trễ"; btnDown.BackgroundColor3 = Color3.fromRGB(50,50,60); btnDown.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btnDown)
    local btnUp = Instance.new("TextButton", row); btnUp.Size = UDim2.new(0.48,0,1,0); btnUp.Position = UDim2.new(0.52,0,0,0); btnUp.Text = "+ Tăng trễ"; btnUp.BackgroundColor3 = Color3.fromRGB(50,50,60); btnUp.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btnUp)

    btnDown.MouseButton1Click:Connect(function() data.SkillDelay = math.max(0.1, data.SkillDelay - 0.1); delayLabel.Text = "Độ trễ Skill: "..string.format("%.1f", data.SkillDelay).."s"; save() end)
    btnUp.MouseButton1Click:Connect(function() data.SkillDelay = math.min(5.0, data.SkillDelay + 0.1); delayLabel.Text = "Độ trễ Skill: "..string.format("%.1f", data.SkillDelay).."s"; save() end)

    for _, k in pairs({"Z","X","C","V","F"}) do
        local b = Instance.new("TextButton", right); b.Size = UDim2.new(1,-10,0,35); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        local function update() b.Text = "Auto Skill [ "..k.." ] : "..(data.Skill[k] and "ON" or "OFF"); b.BackgroundColor3 = data.Skill[k] and Color3.fromRGB(255,200,0) or Color3.fromRGB(40,40,45); b.TextColor3 = data.Skill[k] and Color3.new(0,0,0) or Color3.new(1,1,1) end
        update()
        b.MouseButton1Click:Connect(function() data.Skill[k] = not data.Skill[k]; update(); save() end)
    end
end

-- 4. TAB MISC (TÍNH NĂNG MỚI ĐƯỢC YÊU CẦU)
local function MiscTab()
    toggle("ESP Người Chơi (Nhìn Xuyên Tường)", function()
        while data.States["ESP Người Chơi (Nhìn Xuyên Tường)"] do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("BananaESP") then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Name = "BananaESP"; hl.FillColor = Color3.fromRGB(255, 0, 0); hl.OutlineColor = Color3.new(1,1,1)
                end
            end
            task.wait(1)
        end
        -- Tắt ESP
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("BananaESP") then p.Character.BananaESP:Destroy() end
        end
    end)

    toggle("Chạy Nhanh (WalkSpeed 120)", function()
        while data.States["Chạy Nhanh (WalkSpeed 120)"] do
            pcall(function() getHum().WalkSpeed = 120 end)
            task.wait(0.1)
        end
        pcall(function() getHum().WalkSpeed = 16 end) -- Trả về tốc độ gốc
    end)

    toggle("Nhảy Vô Hạn (Inf Jump)", function()
        local c = UIS.JumpRequest:Connect(function()
            if data.States["Nhảy Vô Hạn (Inf Jump)"] then pcall(function() getHum():ChangeState(Enum.HumanoidStateType.Jumping) end) end
        end)
        while data.States["Nhảy Vô Hạn (Inf Jump)"] do task.wait(1) end
        c:Disconnect()
    end)

    toggle("Đi Xuyên Tường (Noclip)", function()
        local c = RunService.Stepped:Connect(function()
            if not data.States["Đi Xuyên Tường (Noclip)"] then return end
            pcall(function()
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
                end
            end)
        end)
        while data.States["Đi Xuyên Tường (Noclip)"] do task.wait(1) end
        c:Disconnect()
    end)
end

-- 5. TAB CÀI ĐẶT CHUNG (SETTINGS)
local function SettingTab()
   toggle("Siêu Fix Lag & Tăng FPS", function()

    if setfpscap then
        setfpscap(120)
    end

    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0

    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
    end

    local count = 0

    for _,v in pairs(game:GetDescendants()) do
        pcall(function()

            -- Part
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0

                if not v:IsDescendantOf(player.Character) then
                    v.CastShadow = false
                end
            end

            -- Xoá hiệu ứng
            if v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Smoke")
            or v:IsA("Fire")
            or v:IsA("Sparkles")
            or v:IsA("Explosion")
            or v:IsA("Beam") then
                v:Destroy()
            end

            -- Xoá texture
            if v:IsA("Decal")
            or v:IsA("Texture") then
                v.Transparency = 1
            end

            -- Giảm lag UI
            if v:IsA("BlurEffect")
            or v:IsA("SunRaysEffect")
            or v:IsA("BloomEffect")
            or v:IsA("ColorCorrectionEffect")
            or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end

            -- Mesh
            if v:IsA("SpecialMesh") then
                v.TextureId = ""
            end

        end)

        count += 1

        if count % 300 == 0 then
            task.wait()
        end
    end

    data.States["Siêu Fix Lag & Tăng FPS"] = false

end)
    toggle("Anti AFK (Chống văng)", function()
        player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)

    toggle("Auto Kết Nối Lại (Auto Reconnect)", function()
        while data.States["Auto Kết Nối Lại (Auto Reconnect)"] do
            pcall(function()
                local prompt = CoreGui:FindFirstChild("RobloxPromptGui")
                if prompt and prompt:FindFirstChild("promptOverlay") and prompt.promptOverlay:FindFirstChild("ErrorPrompt") then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
                end
            end)
            task.wait(3)
        end
    end)
end

-- 6. TAB CODES
local function CodeTab()
    local title = Instance.new("TextLabel", right); title.Size = UDim2.new(1,0,0,30); title.Text = "DANH SÁCH CODES"; title.TextColor3 = Color3.new(1,1,1); title.Font = Enum.Font.GothamBold; title.TextSize = 18; title.BackgroundTransparency = 1
    
    local function addGameCodes(gName, codes)
        local f = Instance.new("Frame", right); f.Size = UDim2.new(1,-10,0,(#codes*32)+35); f.BackgroundColor3 = Color3.fromRGB(35,35,40); Instance.new("UICorner", f)
        local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,0,25); t.Position = UDim2.new(0,10,0,5); t.Text = gName; t.TextColor3 = Color3.fromRGB(255,200,0); t.Font = Enum.Font.GothamBold; t.TextXAlignment = "Left"; t.BackgroundTransparency = 1
        local y = 35
        for _, c in pairs(codes) do
            local b = Instance.new("TextButton", f); b.Size = UDim2.new(1,-20,0,25); b.Position = UDim2.new(0,10,0,y); b.Text = "📋 "..c; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextXAlignment = "Left"; b.BackgroundTransparency = 1
            b.MouseButton1Click:Connect(function() if setclipboard then setclipboard(c); b.Text = "✅ ĐÃ COPY: "..c; task.wait(1.5); b.Text = "📋 "..c end end)
            y = y + 30
        end
    end

    addGameCodes("Slime RNG", {"giveMeLuckNOW","test","gullible"})
    addGameCodes("Sailor Piece", {"TYSMFOR400KFOLLOWONEVENT","1M100KLIKESTYYY","1B300MVISITS","1B200MVISITS","1B100MVISITS","DELAYCODENR2","DELAYCODENR1","RAIDS","HUGEUPDATEWWW"})
end

-- [ GẮN KẾT MENU TRÁI ]
local function setupTab(name, func)
    local b = Instance.new("TextButton", left); b.Size = UDim2.new(1,0,0,35); b.Text = "  "..name; b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.GothamBold; b.TextXAlignment = "Left"; b.BackgroundTransparency = 1
    b.MouseButton1Click:Connect(function() clear(); func() end)
end

setupTab("Main Hubs", MainTab)
setupTab("Cày Cuốc (Farm)", FarmTab)
setupTab("Xả Chiêu (Skills)", SkillTab)
setupTab("Tiện Ích (Misc)", MiscTab)
setupTab("Cài Đặt (Setting)", SettingTab)
setupTab("Copy Code", CodeTab)

clear(); MainTab()end

local function getHum()
    return player.Character and player.Character:FindFirstChildOfClass("Humanoid")
end

local function isAlive()
    local hum = getHum()
    return hum and hum.Health > 0
end

-- [ VÒNG LẶP SKILL (UNIVERSAL - MỌI GAME) ]
local skillUsing = false
task.spawn(function()
    while task.wait(0.1) do
        if not isAlive() or skillUsing then continue end

        for _, key in pairs({"Z","X","C","V","F"}) do
            if data.Skill[key] then
                skillUsing = true
                pcall(function()
                    -- Giả lập bấm phím vật lý (chạy được trên 99% game)
                    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                    task.wait(0.05)
                    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                end)
                task.wait(data.SkillDelay)
                skillUsing = false
            end
        end
    end
end)

-- [ GIAO DIỆN CHÍNH (GUI) ]
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "BananaLiteUniversal"
gui.ResetOnSpawn = false

-- Nút mở menu mini
local mini = Instance.new("ImageButton", gui)
mini.Size = UDim2.new(0, 45, 0, 45)
mini.Position = UDim2.new(0.02, 0, 0.3, 0)
mini.BackgroundTransparency = 1
mini.Image = "rbxassetid://113151661733524"
Instance.new("UICorner", mini)

-- Khung Main
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 650, 0, 400)
main.Position = UDim2.new(0.5, -325, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Visible = false
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 200, 0)
stroke.Thickness = 1.5

mini.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- Kéo thả mượt mà
local function dragify(Frame)

    local dragToggle = false
    local dragInput
    local dragStart
    local startPos

    local function updateInput(input)

        local Delta = input.Position - dragStart

        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + Delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + Delta.Y
        )
    end

    Frame.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()

                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end

            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

            dragInput = input

        end
    end)

    UIS.InputChanged:Connect(function(input)

        if input == dragInput and dragToggle then
            updateInput(input)
        end

    end)
end
dragify(main)
dragify(mini)

-- Layout Trái / Phải
local left = Instance.new("Frame", main); left.Size = UDim2.new(0, 140, 1, -20); left.Position = UDim2.new(0, 10, 0, 10); left.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", left)
Instance.new("UIListLayout", left).Padding = UDim.new(0, 5)

local right = Instance.new("ScrollingFrame", main); right.Size = UDim2.new(1, -165, 1, -20); right.Position = UDim2.new(0, 155, 0, 10); right.BackgroundTransparency = 1; right.ScrollBarThickness = 3
local right = Instance.new("ScrollingFrame", main)
right.Size = UDim2.new(1, -165, 1, -20)
right.Position = UDim2.new(0, 155, 0, 10)
right.BackgroundTransparency = 1
right.ScrollBarThickness = 3
right.CanvasSize = UDim2.new(0,0,5,0)
right.AutomaticCanvasSize = Enum.AutomaticSize.Y
right.ScrollingDirection = Enum.ScrollingDirection.Y
right.BorderSizePixel = 0

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = right

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    right.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

local function clear()
    for _, v in pairs(right:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end
end

-- Hàm tạo Toggles chuẩn hóa
local function toggle(name, func)
    data.States[name] = data.States[name] or false
    local frame = Instance.new("Frame", right); frame.Size = UDim2.new(1, -10, 0, 35); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", frame)
    local text = Instance.new("TextLabel", frame); text.Size = UDim2.new(1, -50, 1, 0); text.Position = UDim2.new(0, 10, 0, 0); text.Text = name; text.TextColor3 = Color3.new(1,1,1); text.Font = Enum.Font.Gotham; text.TextXAlignment = "Left"; text.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 25, 0, 25); btn.Position = UDim2.new(1, -35, 0.5, -12); btn.Text = ""; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local function updateUI()
        btn.BackgroundColor3 = data.States[name] and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(60, 60, 65)
    end
    updateUI()

    if data.States[name] and not _G.Running[name] then
        _G.Running[name] = true; task.spawn(func)
    end

    btn.MouseButton1Click:Connect(function()
        data.States[name] = not data.States[name]; updateUI(); save()
        if data.States[name] then _G.Running[name] = true; task.spawn(func) else _G.Running[name] = false end
    end)
end

-- [ TẠO CÁC TABS ]

-- 1. TAB MAIN (Hubs)
local function MainTab()
    toggle("Quantum Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/main/QuantumOnyx.lua"))() data.States["Quantum Hub"] = false end)
    toggle("Lọ Vương Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/anuragaming1/anura/main/soclo.lua"))() data.States["Lọ Vương Hub"] = false end)
    toggle("Chiyo Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kaisenlmao/loader/main/chiyo.lua"))() data.States["Chiyo Hub"] = false end)
end

-- 2. TAB FARM
local function FarmTab()
    local wLabel = Instance.new("TextLabel", right); wLabel.Size = UDim2.new(1,0,0,25); wLabel.Text = "Weapon : "..(data.Weapon == "" and "NONE" or data.Weapon); wLabel.TextColor3 = Color3.new(1,1,1); wLabel.BackgroundTransparency = 1; wLabel.Font = Enum.Font.Gotham
    local setBtn = Instance.new("TextButton", right); setBtn.Size = UDim2.new(1,-10,0,30); setBtn.Text = "LƯU VŨ KHÍ & VỊ TRÍ"; setBtn.BackgroundColor3 = Color3.fromRGB(45,45,50); setBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", setBtn)
    
    setBtn.MouseButton1Click:Connect(function()
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then data.Weapon = tool.Name; wLabel.Text = "Weapon : "..tool.Name end
        if root() then data.Farm = root().CFrame end; save()
    end)

    toggle("Tự động cầm Vũ khí (Auto Equip)", function()
        while data.States["Tự động cầm Vũ khí (Auto Equip)"] do
            pcall(function()
                if data.Weapon ~= "" then
                    local tool = player.Backpack:FindFirstChild(data.Weapon)
                    if tool then getHum():EquipTool(tool) end
                end
            end)
            task.wait(0.5)
        end
    end)
 local resetBtn = Instance.new("TextButton", right)
resetBtn.Size = UDim2.new(1,-10,0,30)
resetBtn.Text = "RESET FARM"
resetBtn.BackgroundColor3 = Color3.fromRGB(120,35,35)
resetBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", resetBtn)

resetBtn.MouseButton1Click:Connect(function()

    data.Weapon = ""
    data.Farm = nil

    save()

    wLabel.Text = "Weapon : NONE"

end)

    toggle("Teleport tới điểm Farm", function()
        while data.States["Teleport tới điểm Farm"] do
            pcall(function() if data.Farm and root() then root().CFrame = data.Farm end end)
            task.wait(0.1)
        end
    end)
    
    toggle("Auto Click Chuột Trái", function()
        while data.States["Auto Click Chuột Trái"] do
            VirtualUser:ClickButton1(Vector2.new())
            task.wait(0.1)
        end
    end)
end

-- 3. TAB SKILLS
local function SkillTab()
    local delayLabel = Instance.new("TextLabel", right); delayLabel.Size = UDim2.new(1,0,0,25); delayLabel.Text = "Độ trễ Skill: "..data.SkillDelay.."s"; delayLabel.TextColor3 = Color3.fromRGB(255,200,0); delayLabel.Font = Enum.Font.GothamBold; delayLabel.BackgroundTransparency = 1
    
    local row = Instance.new("Frame", right); row.Size = UDim2.new(1,-10,0,30); row.BackgroundTransparency = 1
    local btnDown = Instance.new("TextButton", row); btnDown.Size = UDim2.new(0.48,0,1,0); btnDown.Text = "- Giảm trễ"; btnDown.BackgroundColor3 = Color3.fromRGB(50,50,60); btnDown.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btnDown)
    local btnUp = Instance.new("TextButton", row); btnUp.Size = UDim2.new(0.48,0,1,0); btnUp.Position = UDim2.new(0.52,0,0,0); btnUp.Text = "+ Tăng trễ"; btnUp.BackgroundColor3 = Color3.fromRGB(50,50,60); btnUp.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btnUp)

    btnDown.MouseButton1Click:Connect(function() data.SkillDelay = math.max(0.1, data.SkillDelay - 0.1); delayLabel.Text = "Độ trễ Skill: "..string.format("%.1f", data.SkillDelay).."s"; save() end)
    btnUp.MouseButton1Click:Connect(function() data.SkillDelay = math.min(5.0, data.SkillDelay + 0.1); delayLabel.Text = "Độ trễ Skill: "..string.format("%.1f", data.SkillDelay).."s"; save() end)

    for _, k in pairs({"Z","X","C","V","F"}) do
        local b = Instance.new("TextButton", right); b.Size = UDim2.new(1,-10,0,35); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        local function update() b.Text = "Auto Skill [ "..k.." ] : "..(data.Skill[k] and "ON" or "OFF"); b.BackgroundColor3 = data.Skill[k] and Color3.fromRGB(255,200,0) or Color3.fromRGB(40,40,45); b.TextColor3 = data.Skill[k] and Color3.new(0,0,0) or Color3.new(1,1,1) end
        update()
        b.MouseButton1Click:Connect(function() data.Skill[k] = not data.Skill[k]; update(); save() end)
    end
end

-- 4. TAB MISC (TÍNH NĂNG MỚI ĐƯỢC YÊU CẦU)
local function MiscTab()
    toggle("ESP Người Chơi (Nhìn Xuyên Tường)", function()
        while data.States["ESP Người Chơi (Nhìn Xuyên Tường)"] do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("BananaESP") then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Name = "BananaESP"; hl.FillColor = Color3.fromRGB(255, 0, 0); hl.OutlineColor = Color3.new(1,1,1)
                end
            end
            task.wait(1)
        end
        -- Tắt ESP
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("BananaESP") then p.Character.BananaESP:Destroy() end
        end
    end)

    toggle("Chạy Nhanh (WalkSpeed 120)", function()
        while data.States["Chạy Nhanh (WalkSpeed 120)"] do
            pcall(function() getHum().WalkSpeed = 120 end)
            task.wait(0.1)
        end
        pcall(function() getHum().WalkSpeed = 16 end) -- Trả về tốc độ gốc
    end)

    toggle("Nhảy Vô Hạn (Inf Jump)", function()
        local c = UIS.JumpRequest:Connect(function()
            if data.States["Nhảy Vô Hạn (Inf Jump)"] then pcall(function() getHum():ChangeState(Enum.HumanoidStateType.Jumping) end) end
        end)
        while data.States["Nhảy Vô Hạn (Inf Jump)"] do task.wait(1) end
        c:Disconnect()
    end)

    toggle("Đi Xuyên Tường (Noclip)", function()
        local c = RunService.Stepped:Connect(function()
            if not data.States["Đi Xuyên Tường (Noclip)"] then return end
            pcall(function()
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
                end
            end)
        end)
        while data.States["Đi Xuyên Tường (Noclip)"] do task.wait(1) end
        c:Disconnect()
    end)
end

-- 5. TAB CÀI ĐẶT CHUNG (SETTINGS)
local function SettingTab()
    toggle("Siêu Fix Lag & Tăng FPS", function()
        if setfpscap then setfpscap(120) end
        game:GetService("Lighting").GlobalShadows = false
        settings().Rendering.QualityLevel = 1
        
        -- Chia nhỏ việc tải để không bị đơ game lúc đầu
        local count = 0
        for _, v in pairs(workspace:GetDescendants()) do
            pcall(function()
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic; v.Reflectance = 0
                elseif v:IsA("Texture") or v:IsA("Decal") or v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v:Destroy()
                end
            end)
            count = count + 1
            if count % 500 == 0 then task.wait() end -- Tránh đứng máy
        end
        data.States["Siêu Fix Lag & Tăng FPS"] = false -- Chạy 1 lần là đủ
    end)

    toggle("Anti AFK (Chống văng)", function()
        player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)

    toggle("Auto Kết Nối Lại (Auto Reconnect)", function()
        while data.States["Auto Kết Nối Lại (Auto Reconnect)"] do
            pcall(function()
                local prompt = CoreGui:FindFirstChild("RobloxPromptGui")
                if prompt and prompt:FindFirstChild("promptOverlay") and prompt.promptOverlay:FindFirstChild("ErrorPrompt") then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
                end
            end)
            task.wait(3)
        end
    end)
end

-- 6. TAB CODES
local function CodeTab()
    local title = Instance.new("TextLabel", right); title.Size = UDim2.new(1,0,0,30); title.Text = "DANH SÁCH CODES"; title.TextColor3 = Color3.new(1,1,1); title.Font = Enum.Font.GothamBold; title.TextSize = 18; title.BackgroundTransparency = 1
    
    local function addGameCodes(gName, codes)
        local f = Instance.new("Frame", right); f.Size = UDim2.new(1,-10,0,(#codes*32)+35); f.BackgroundColor3 = Color3.fromRGB(35,35,40); Instance.new("UICorner", f)
        local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,0,25); t.Position = UDim2.new(0,10,0,5); t.Text = gName; t.TextColor3 = Color3.fromRGB(255,200,0); t.Font = Enum.Font.GothamBold; t.TextXAlignment = "Left"; t.BackgroundTransparency = 1
        local y = 35
        for _, c in pairs(codes) do
            local b = Instance.new("TextButton", f); b.Size = UDim2.new(1,-20,0,25); b.Position = UDim2.new(0,10,0,y); b.Text = "📋 "..c; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextXAlignment = "Left"; b.BackgroundTransparency = 1
            b.MouseButton1Click:Connect(function() if setclipboard then setclipboard(c); b.Text = "✅ ĐÃ COPY: "..c; task.wait(1.5); b.Text = "📋 "..c end end)
            y = y + 30
        end
    end

    addGameCodes("Slime RNG", {"giveMeLuckNOW","test","gullible"})
    addGameCodes("Sailor Piece", {"TYSMFOR400KFOLLOWONEVENT","1M100KLIKESTYYY","1B300MVISITS","1B200MVISITS","1B100MVISITS","DELAYCODENR2","DELAYCODENR1","RAIDS","HUGEUPDATEWWW"})
end

-- [ GẮN KẾT MENU TRÁI ]
local function setupTab(name, func)
    local b = Instance.new("TextButton", left); b.Size = UDim2.new(1,0,0,35); b.Text = "  "..name; b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.GothamBold; b.TextXAlignment = "Left"; b.BackgroundTransparency = 1
    b.MouseButton1Click:Connect(function() clear(); func() end)
end

setupTab("Main Hubs", MainTab)
setupTab("Cày Cuốc (Farm)", FarmTab)
setupTab("Xả Chiêu (Skills)", SkillTab)
setupTab("Tiện Ích (Misc)", MiscTab)
setupTab("Cài Đặt (Setting)", SettingTab)
setupTab("Copy Code", CodeTab)

clear(); MainTab()
