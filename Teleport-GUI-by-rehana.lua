local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Teleport GUI by rehana$"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 1, -30)
PlayerList.Position = UDim2.new(0, 0, 0, 30)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ScrollBarThickness = 6
PlayerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerList.BorderSizePixel = 0
PlayerList.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = PlayerList

local IconBtn = Instance.new("TextButton")
IconBtn.Size = UDim2.new(0, 60, 0, 60)
IconBtn.Position = UDim2.new(0, 20, 0.7, 0)
IconBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
IconBtn.BackgroundTransparency = 0.3
IconBtn.Text = "TP gui"
IconBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IconBtn.Font = Enum.Font.SourceSansBold
IconBtn.TextSize = 14
IconBtn.Visible = false
IconBtn.Active = true
IconBtn.Draggable = true
IconBtn.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = IconBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	IconBtn.Visible = true
end)

IconBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	IconBtn.Visible = false
end)

local function teleportTo(plr)
	if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
	end
end

local function createButton(player)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -10, 0, 30)
	Btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.Font = Enum.Font.SourceSansBold
	Btn.TextSize = 14
	Btn.Text = player.Name
	Btn.Parent = PlayerList
	Btn.MouseButton1Click:Connect(function()
		teleportTo(player)
	end)
end

local function updateList()
	for _, child in ipairs(PlayerList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			createButton(plr)
		end
	end
end

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()
