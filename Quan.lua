repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local Vim = game:GetService("VirtualInputManager")

-- AUTO REJOIN SAME SERVER
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local _placeId = game.PlaceId
local _jobId = game.JobId

local function _rejoin()
task.wait(2)
pcall(function()
TeleportService:TeleportToPlaceInstance(_placeId,_jobId,player)
end)
end

pcall(function()
CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
if child.Name == "ErrorPrompt" then
_rejoin()
end
end)
end)

player.OnTeleport:Connect(function(state)
if state == Enum.TeleportState.Failed then
_rejoin()
end
end)

-- SAVE
local file="BananaLite.json"

local data={
States={},
Weapon="",
Farm=nil,
Skill={
Z=false,
X=false,
C=false,
V=false,
F=false
}
}

if isfile and isfile(file) then
data=HttpService:JSONDecode(readfile(file))
end

local function save()
if writefile then
writefile(file,HttpService:JSONEncode(data))
end
end

local function root()
return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- GUI
local gui=Instance.new("ScreenGui",player.PlayerGui)
gui.ResetOnSpawn=false

-- ICON
local mini=Instance.new("ImageButton",gui)
mini.Size=UDim2.new(0,45,0,45)
mini.Position=UDim2.new(0.02,0,0.3,0)
mini.Image="rbxassetid://113151661733524"
mini.BackgroundTransparency=1

-- MAIN
local main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,650,0,380)
main.Position=UDim2.new(0.5,-325,0.5,-190)
main.BackgroundColor3=Color3.fromRGB(20,20,25)
main.Visible=false

mini.MouseButton1Click:Connect(function()
main.Visible=not main.Visible
end)

-- DRAG
local function drag(frame)
local dragging=false
local dragInput
local dragStart
local startPos

local function update(input)
local delta=input.Position-dragStart
frame.Position=UDim2.new(
startPos.X.Scale,
startPos.X.Offset+delta.X,
startPos.Y.Scale,
startPos.Y.Offset+delta.Y
)
end

frame.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 
or input.UserInputType==Enum.UserInputType.Touch then
dragging=true
dragStart=input.Position
startPos=frame.Position

input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then
dragging=false
end end)
end end)

frame.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement 
or input.UserInputType==Enum.UserInputType.Touch then
dragInput=input
end end)

UIS.InputChanged:Connect(function(input)
if input==dragInput and dragging then
update(input)
end end)
end

drag(main)
drag(mini)

-- TITLE
local title=Instance.new("TextLabel",main)
title.Size=UDim2.new(1,0,0,30)
title.Text="Quân Hub"
title.TextColor3=Color3.fromRGB(255,210,120)
title.BackgroundTransparency=1
title.TextScaled=true

-- LEFT
local left=Instance.new("Frame",main)
left.Size=UDim2.new(0,150,1,-30)
left.Position=UDim2.new(0,0,0,30)
left.BackgroundColor3=Color3.fromRGB(25,25,30)

Instance.new("UIListLayout",left).Padding=UDim.new(0,5)

-- RIGHT
local right=Instance.new("ScrollingFrame",main)
right.Size=UDim2.new(1,-160,1,-30)
right.Position=UDim2.new(0,160,0,30)
right.BackgroundTransparency=1
right.AutomaticCanvasSize=Enum.AutomaticSize.Y
right.ScrollBarThickness=6

local layout=Instance.new("UIListLayout",right)
layout.Padding=UDim.new(0,6)

local function clear()
for _,v in pairs(right:GetChildren()) do
if not v:IsA("UIListLayout") then
v:Destroy()
end end end

-- TOGGLE
local function toggle(name,func)

data.States[name]=data.States[name] or false

local frame=Instance.new("Frame",right)
frame.Size=UDim2.new(1,0,0,35)
frame.BackgroundColor3=Color3.fromRGB(30,30,35)

local text=Instance.new("TextLabel",frame)
text.Size=UDim2.new(1,-35,1,0)
text.Position=UDim2.new(0,10,0,0)
text.Text=name
text.TextColor3=Color3.new(1,1,1)
text.BackgroundTransparency=1
text.TextXAlignment="Left"

local btn=Instance.new("TextButton",frame)
btn.Size=UDim2.new(0,18,0,18)
btn.Position=UDim2.new(1,-25,0.5,-9)

local function update()
btn.BackgroundColor3=data.States[name]
and Color3.fromRGB(255,200,0)
or Color3.fromRGB(50,50,50)
end
update()

btn.MouseButton1Click:Connect(function()
data.States[name]=not data.States[name]
update()
save()
if data.States[name] then
task.spawn(func)
end
end)

end

-- MAIN TAB
local function MainTab()

toggle("Quantum Hub",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/main/QuantumOnyx.lua"))()
end)

toggle("Lọ Vương Hub",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/anuragaming1/anura/main/soclo.lua"))()
end)

toggle("Chiyo Hub",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/kaisenlmao/loader/main/chiyo.lua"))()
end)

end

-- FARM TAB
local function FarmTab()

local label=Instance.new("TextLabel",right)
label.Size=UDim2.new(1,0,0,20)
label.Text="Weapon : "..(data.Weapon=="" and "NONE" or data.Weapon)
label.TextColor3=Color3.new(1,1,1)
label.BackgroundTransparency=1

local set=Instance.new("TextButton",right)
set.Size=UDim2.new(0.5,-5,0,25)
set.Text="SET Weapon"

local reset=Instance.new("TextButton",right)
reset.Size=UDim2.new(0.5,-5,0,25)
reset.Position=UDim2.new(0.5,5,0,0)
reset.Text="RESET Weapon"

set.MouseButton1Click:Connect(function()
local tool=player.Character:FindFirstChildOfClass("Tool")
if tool then
data.Weapon=tool.Name
label.Text="Weapon : "..tool.Name
save()
end end)

reset.MouseButton1Click:Connect(function()
data.Weapon=""
label.Text="Weapon : NONE"
save()
end)

toggle("Auto Equip Weapon",function()
while data.States["Auto Equip Weapon"] do
pcall(function()
if data.Weapon~="" then
local tool=player.Backpack:FindFirstChild(data.Weapon)
if tool then
player.Character.Humanoid:EquipTool(tool)
end end
end)
task.wait(.5)
end end)

local farmLabel=Instance.new("TextLabel",right)
farmLabel.Size=UDim2.new(1,0,0,20)
farmLabel.Text="Farm : "..(data.Farm and "SAVED" or "NONE")
farmLabel.BackgroundTransparency=1
farmLabel.TextColor3=Color3.new(1,1,1)

local setF=Instance.new("TextButton",right)
setF.Size=UDim2.new(0.5,-5,0,25)
setF.Text="SET Farm"

local resetF=Instance.new("TextButton",right)
resetF.Size=UDim2.new(0.5,-5,0,25)
resetF.Position=UDim2.new(0.5,5,0,0)
resetF.Text="RESET Farm"

setF.MouseButton1Click:Connect(function()
data.Farm=root().CFrame
farmLabel.Text="Farm : SAVED"
save()
end)

resetF.MouseButton1Click:Connect(function()
data.Farm=nil
farmLabel.Text="Farm : NONE"
save()
end)

toggle("Teleport Farm",function()
while data.States["Teleport Farm"] do
pcall(function()
if data.Farm then
root().CFrame=data.Farm
end
end)
task.wait(.3)
end end)

toggle("Lock Position",function()
local pos=root().CFrame
while data.States["Lock Position"] do
pcall(function()
root().CFrame=pos
end)
task.wait()
end end)

end

-- SKILL TAB
local function SkillTab()

local function skill(key)

local b=Instance.new("TextButton",right)
b.Size=UDim2.new(1,0,0,30)

local function update()
b.Text=key.." : "..(data.Skill[key] and "ON" or "OFF")
end
update()

b.MouseButton1Click:Connect(function()
data.Skill[key]=not data.Skill[key]
update()
save()
end)

end

skill("Z")
skill("X")
skill("C")
skill("V")
skill("F")

toggle("Auto Skill",function()

local function press(k)
Vim:SendKeyEvent(true,Enum.KeyCode[k],false,game)
task.wait(.1)
Vim:SendKeyEvent(false,Enum.KeyCode[k],false,game)
end

while data.States["Auto Skill"] do

for _,k in pairs({"Z","X","C","V","F"}) do
if data.Skill[k] then
press(k)
task.wait(.25)
end
end

task.wait(.1)
end

end)

end

-- SETTING
local function SettingTab()

toggle("Anti AFK + Anti Kick",function()

player.Idled:Connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)

while data.States["Anti AFK + Anti Kick"] do
VirtualUser:CaptureController()
VirtualUser:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
task.wait(10)
end

end)

toggle("Fix Lag",function()
for _,v in pairs(workspace:GetDescendants()) do
pcall(function()
if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Explosion") then
v.Enabled=false
end
end)
end
end)

toggle("Hide Skill Others",function()
for _,v in pairs(workspace:GetDescendants()) do
pcall(function()
if v:IsA("ParticleEmitter") and not v:IsDescendantOf(player.Character) then
v.Enabled=false
end
end)
end
end)

end

-- TAB
local function tab(name,func)
local b=Instance.new("TextButton",left)
b.Size=UDim2.new(1,0,0,30)
b.Text=name
b.BackgroundTransparency=1
b.TextColor3=Color3.new(1,1,1)

b.MouseButton1Click:Connect(function()
clear()
func()
end)
end

tab("Main",MainTab)
tab("Farm",FarmTab)
tab("Skills",SkillTab)
tab("Setting",SettingTab)

clear()
MainTab()
