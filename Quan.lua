-- QUÂN ULTRA HUB PRO MAX V11 (FULL ALL)

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- ===== SAVE =====
local fileName = "QuanHubPro.json"
local setting = {
	AutoActivate = false,
	Scripts = {
		["Anti AFK"] = false,
		["Blox Fruits"] = false,
		["Sailor Piece"] = false
	}
}

if isfile and isfile(fileName) then
	setting = HttpService:JSONDecode(readfile(fileName))
end

local function save()
	if writefile then
		writefile(fileName, HttpService:JSONEncode(setting))
	end
end

-- ===== HTTP =====
local function get(url)
	local success, result = pcall(function()
		return game:HttpGet(url)
	end)
	if success and result then
		return result
	else
		warn("HTTP FAIL:", url)
		return nil
	end
end

-- ===== ANTI AFK PRO MAX =====
local antiAFKRunning = false

local function startAntiAFK()
	if antiAFKRunning then return end
	antiAFKRunning = true

	-- LOAD SCRIPT GITHUB
	task.spawn(function()
		local success, err = pcall(function()
			local code = get("https://raw.githubusercontent.com/uubinok1222/Anti-afk/refs/heads/main/By%20chatgpt")
			if code then loadstring(code)() end
		end)
		if not success then
			warn("Anti AFK load lỗi:", err)
		end
	end)

	-- CLICK LOOP
	task.spawn(function()
		while antiAFKRunning do
			local vu = game:GetService("VirtualUser")
			vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(60)
		end
	end)
end

local function stopAntiAFK()
	antiAFKRunning = false
end

-- ===== RUN SCRIPT =====
local function runScript(name, state)
	setting.Scripts[name] = state
	save()

	if name == "Anti AFK" then
		if state then
			startAntiAFK()
		else
			stopAntiAFK()
		end
		return
	end

	if not state then return end

	task.spawn(function()
		local success, err = pcall(function()

			if name == "Blox Fruits" then
				local code = get("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz.lua")
				if code then loadstring(code)() end

			elseif name == "Sailor Piece" then
				local code = get("https://raw.githubusercontent.com/kaisenlmao/loader/main/chiyo.lua")
				if code then loadstring(code)() end

			end

		end)

		if success then
			pcall(function()
				StarterGui:SetCore("SendNotification",{
					Title = "✅ SUCCESS",
					Text = name.." đã chạy",
					Duration = 3
				})
			end)
		else
			warn(err)
			pcall(function()
				StarterGui:SetCore("SendNotification",{
					Title = "❌ ERROR",
					Text = name.." lỗi!",
					Duration = 5
				})
			end)
		end
	end)
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.new(0,50,0,50)
mini.Position = UDim2.new(0.05,0,0.3,0)
mini.Text = "Q"
mini.BackgroundColor3 = Color3.fromRGB(0,200,255)
mini.TextColor3 = Color3.new(1,1,1)
mini.Active = true
mini.Draggable = true

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,400,0,360)
menu.Position = UDim2.new(0.3,0,0.2,0)
menu.BackgroundColor3 = Color3.fromRGB(25,25,25)
menu.Visible = false
menu.Active = true
menu.Draggable = true

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1,0,0,40)
title.Text = "QUÂN HUB V11 PRO MAX"
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.fromRGB(0,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Avatar
local avatar = Instance.new("ImageLabel", menu)
avatar.Size = UDim2.new(0,70,0,70)
avatar.Position = UDim2.new(0,10,0,45)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=420&h=420"
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

mini.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Tabs
local tabs = {}
local function createTab(name)
	local t = Instance.new("Frame", menu)
	t.Size = UDim2.new(1,-10,1,-130)
	t.Position = UDim2.new(0,5,0,120)
	t.Visible = false
	t.BackgroundTransparency = 1
	tabs[name] = t
	return t
end

local antiTab = createTab("Anti AFK")
local bloxTab = createTab("Blox Fruits")
local sailorTab = createTab("Sailor Piece")
local settingTab = createTab("Setting")

tabs["Anti AFK"].Visible = true

-- Toggle
local function makeToggle(parent, keyName, displayName, y)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0,220,0,50)
	btn.Position = UDim2.new(0.1,0,y,0)

	local function update()
		btn.Text = displayName..": "..(setting.Scripts[keyName] and "ON" or "OFF")
	end

	update()

	btn.MouseButton1Click:Connect(function()
		local newState = not setting.Scripts[keyName]
		runScript(keyName, newState)
		update()
	end)
end

makeToggle(antiTab,"Anti AFK","Anti AFK",0.2)
makeToggle(bloxTab,"Blox Fruits","REDz Hub",0.2)
makeToggle(sailorTab,"Sailor Piece","Chiyo Hub",0.2)

-- Setting
local autoBtn = Instance.new("TextButton", settingTab)
autoBtn.Size = UDim2.new(0,220,0,50)
autoBtn.Position = UDim2.new(0.1,0,0.2,0)

local function updateAuto()
	autoBtn.Text = "Auto Activate: "..(setting.AutoActivate and "ON" or "OFF")
end

updateAuto()

autoBtn.MouseButton1Click:Connect(function()
	setting.AutoActivate = not setting.AutoActivate
	save()
	updateAuto()
end)

-- Run All
local runAll = Instance.new("TextButton", settingTab)
runAll.Size = UDim2.new(0,220,0,50)
runAll.Position = UDim2.new(0.1,0,0.5,0)
runAll.Text = "RUN ALL"

runAll.MouseButton1Click:Connect(function()
	for name,_ in pairs(setting.Scripts) do
		runScript(name,true)
	end
end)

-- Tabs switch
local names = {"Anti AFK","Blox Fruits","Sailor Piece","Setting"}
for i,n in ipairs(names) do
	local b = Instance.new("TextButton", menu)
	b.Size = UDim2.new(0,90,0,30)
	b.Position = UDim2.new(0,(i-1)*100,0,90)
	b.Text = n
	
	b.MouseButton1Click:Connect(function()
		for _,v in pairs(tabs) do v.Visible = false end
		tabs[n].Visible = true
	end)
end

-- Auto run
task.spawn(function()
	wait(2)
	if setting.AutoActivate then
		for name,state in pairs(setting.Scripts) do
			if state then
				runScript(name,true)
			end
		end
	end
end)
