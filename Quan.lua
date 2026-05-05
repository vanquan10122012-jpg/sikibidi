repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local Vim = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")

-- [ 1. HỆ THỐNG LƯU TRỮ ]
local file = "BananaLite.json"
local data = {
    States = {},
    Weapon = "",
    Farm = nil,
    Skill = { Z = false, X = false, C = false, V = false, F = false }
}

-- Bảng tạm để kiểm tra xem tính năng đã đang chạy hay chưa (Tránh bị lặp vòng lặp)
_G.Running = _G.Running or {}

if isfile and isfile(file) then 
    local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(file)) end)
    if success then data = decoded end
end

local function save() 
    if writefile then writefile(file, HttpService:JSONEncode(data)) end 
end

local function root() 
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart") 
end

-- [ 2. GIAO DIỆN ]
local gui = Instance.new("ScreenGui", player.PlayerGui); gui.ResetOnSpawn = false
local mini = Instance.new("ImageButton", gui); mini.Size = UDim2.new(0, 45, 0, 45); mini.Position = UDim2.new(0.02, 0, 0.3, 0); mini.Image = "rbxassetid://113151661733524"; mini.BackgroundTransparency = 1; Instance.new("UICorner", mini)
local main = Instance.new("Frame", gui); main.Size = UDim2.new(0, 650, 0, 380); main.Position = UDim2.new(0.5, -325, 0.5, -190); main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); main.Visible = false; Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main); stroke.Color = Color3.fromRGB(255, 210, 120); stroke.Thickness = 1.5

mini.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- Kéo GUI
local function drag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
end
drag(main); drag(mini)

-- MENU TRÁI & PHẢI
local left = Instance.new("Frame", main); left.Size = UDim2.new(0, 150, 1, -35); left.Position = UDim2.new(0, 0, 0, 35); left.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UIListLayout", left).Padding = UDim.new(0, 5)
local right = Instance.new("ScrollingFrame", main); right.Size = UDim2.new(1, -160, 1, -35); right.Position = UDim2.new(0, 160, 0, 35); right.BackgroundTransparency = 1; right.AutomaticCanvasSize = Enum.AutomaticSize.Y; right.ScrollBarThickness = 4
Instance.new("UIListLayout", right).Padding = UDim.new(0, 6)

local function clear() 
    for _, v in pairs(right:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end 
end

-- [ 3. HÀM TOGGLE THÔNG MINH (FIX LỖI KHÔNG TỰ CHẠY) ]
local function toggle(name, func)
    data.States[name] = data.States[name] or false
    
    local frame = Instance.new("Frame", right); frame.Size = UDim2.new(1, -10, 0, 35); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", frame)
    local text = Instance.new("TextLabel", frame); text.Size = UDim2.new(1, -40, 1, 0); text.Position = UDim2.new(0, 10, 0, 0); text.Text = name; text.TextColor3 = Color3.new(1, 1, 1); text.BackgroundTransparency = 1; text.TextXAlignment = "Left"; text.Font = Enum.Font.Gotham
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 20, 0, 20); btn.Position = UDim2.new(1, -30, 0.5, -10); Instance.new("UICorner", btn)
    
    local function updateUI() 
        btn.BackgroundColor3 = data.States[name] and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(60, 60, 60) 
    end
    updateUI()

    -- TỰ ĐỘNG KÍCH HOẠT NẾU DATA LÀ TRUE
    if data.States[name] and not _G.Running[name] then
        _G.Running[name] = true
        task.spawn(func)
    end

    btn.MouseButton1Click:Connect(function()
        data.States[name] = not data.States[name]
        updateUI(); save()
        if data.States[name] and not _G.Running[name] then
            _G.Running[name] = true
            task.spawn(func)
        elseif not data.States[name] then
            _G.Running[name] = false -- Dừng trạng thái running để có thể bật lại sau
        end
    end)
end

-- [ 4. TABS ]

local function MainTab()
    toggle("Auto Redeem Code TGDĐ", function()
        while data.States["Auto Redeem Code TGDĐ"] do
            pcall(function()
                local url = "https://www.thegioididong.com/game-app/code-cach-nhap-code-sailor-piece-1588013"
                local proxy = "https://api.allorigins.win/get?url=" .. HttpService:UrlEncode(url)
                local res = game:HttpGet(proxy)
                local content = HttpService:JSONDecode(res).contents
                for code in content:gmatch("%u[%u%d]{4,15}") do
                    if not data.States["Auto Redeem Code TGDĐ"] then break end
                    game:GetService("ReplicatedStorage").Remotes.RedeemCode:InvokeServer(code); task.wait(0.5)
                end
            end)
            task.wait(600)
        end
        _G.Running["Auto Redeem Code TGDĐ"] = false
    end)
    toggle("Quantum Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/main/QuantumOnyx.lua"))() end)
    toggle("Lọ Vương Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/anuragaming1/anura/main/soclo.lua"))() end)
    toggle("Chiyo Hub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kaisenlmao/loader/main/chiyo.lua"))() end)
end

local function FarmTab()
    local wLabel = Instance.new("TextLabel", right); wLabel.Size = UDim2.new(1, 0, 0, 20); wLabel.Text = "Weapon: "..(data.Weapon=="" and "NONE" or data.Weapon); wLabel.TextColor3 = Color3.new(1,1,1); wLabel.BackgroundTransparency = 1
    
    local fSet = Instance.new("TextButton", right); fSet.Size = UDim2.new(1, 0, 0, 30); fSet.Text = "SET WEAPON & FARM POS"; fSet.BackgroundColor3 = Color3.fromRGB(45, 45, 50); fSet.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", fSet)
    fSet.MouseButton1Click:Connect(function()
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then data.Weapon = tool.Name; wLabel.Text = "Weapon: "..tool.Name end
        if root() then data.Farm = root().CFrame end
        save()
    end)

    local fReset = Instance.new("TextButton", right); fReset.Size = UDim2.new(1, 0, 0, 30); fReset.Text = "RESET ALL FARM DATA"; fReset.BackgroundColor3 = Color3.fromRGB(80, 20, 20); fReset.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", fReset)
    fReset.MouseButton1Click:Connect(function()
        data.Weapon = ""; data.Farm = nil; wLabel.Text = "Weapon: NONE"; save()
    end)

    toggle("Auto Equip", function()
        while data.States["Auto Equip"] do
            pcall(function() if data.Weapon~="" then player.Character.Humanoid:EquipTool(player.Backpack:FindFirstChild(data.Weapon)) end end); task.wait(0.5)
        end
        _G.Running["Auto Equip"] = false
    end)

    toggle("Teleport Farm", function()
        while data.States["Teleport Farm"] do
            pcall(function() if data.Farm then root().CFrame = data.Farm end end); task.wait(0.1)
        end
        _G.Running["Teleport Farm"] = false
    end)
end

local function SkillTab()
    local function skill(key)
        local b = Instance.new("TextButton", right); b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Color3.fromRGB(40, 40, 45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        local function update() b.Text = key.." : "..(data.Skill[key] and "ON" or "OFF") end
        update()
        b.MouseButton1Click:Connect(function() data.Skill[key] = not data.Skill[key]; update(); save() end)
    end
    for _, k in pairs({"Z","X","C","V","F"}) do skill(k) end

    toggle("Auto Skill (No Freeze)", function()
        local function pressKey(k)
            task.spawn(function()
                local key = Enum.KeyCode[k]
                if keypress then keypress(key.Value); task.wait(0.02); keyrelease(key.Value)
                else Vim:SendKeyEvent(true, key, false, game); task.wait(0.02); Vim:SendKeyEvent(false, key, false, game) end
            end)
        end
        while data.States["Auto Skill (No Freeze)"] do
            for _, k in pairs({"Z","X","C","V","F"}) do if data.Skill[k] then pressKey(k); task.wait(0.2) end end
            task.wait(0.1)
        end
        _G.Running["Auto Skill (No Freeze)"] = false
    end)
end

local function SettingTab()
    -- FIX LAG 120 FPS AUTO-RUN
    toggle("Super Fix Lag + 120 FPS", function()
        if setfpscap then setfpscap(120) end
        
        -- Logic tối ưu đồ họa
        while data.States["Super Fix Lag + 120 FPS"] do
            settings().Rendering.QualityLevel = 1
            game:GetService("Lighting").GlobalShadows = false
            for _, v in pairs(game:GetDescendants()) do
                pcall(function()
                    if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                        v.Material = Enum.Material.Plastic
                        v.Reflectance = 0
                    elseif v:IsA("Decal") or v:IsA("Texture") then
                        v:Destroy()
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                        v.Enabled = false
                    end
                end)
            end
            task.wait(10) -- Chạy lại mỗi 10s để dọn rác mới phát sinh
        end
        _G.Running["Super Fix Lag + 120 FPS"] = false
    end)

    toggle("Anti AFK", function()
        player.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
    end)
end

-- [ 5. KHỞI CHẠY HỆ THỐNG ]
local function tab(name, func)
    local b = Instance.new("TextButton", left); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name; b.BackgroundTransparency = 1; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function() clear(); func() end)
end

tab("Main", MainTab); tab("Farm", FarmTab); tab("Skills", SkillTab); tab("Setting", SettingTab)

-- Tự động chạy tab Main để kích hoạt các Toggle đã lưu
clear()
MainTab()
-- Sau đó kích hoạt ngầm các tab khác để script nhận diện hết các Toggle
task.spawn(function()
    local oldMain = right:GetChildren() -- Lưu lại Main
    FarmTab(); SkillTab(); SettingTab(); -- Gọi để kích hoạt Auto-Run bên trong các hàm toggle
    clear(); MainTab(); -- Quay lại Main cho người dùng
end)
