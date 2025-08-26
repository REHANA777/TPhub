local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local mutedPlayers = {}
local speedEnabled = false
local speedValue = 16
local currentMode = "Teleport"

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.ResetOnSpawn = false

-- Main GUI
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 360)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.3
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Title bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(1, -70, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Teleport GUI by rehana$"
TitleText.TextColor3 = Color3.new(1,1,1)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 3)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 3)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold

-- Tabs
local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(1, 0, 0, 30)
TabFrame.Position = UDim2.new(0, 0, 0, 35)
TabFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local TeleportTab = Instance.new("TextButton", TabFrame)
TeleportTab.Size = UDim2.new(0.33, 0, 1, 0)
TeleportTab.Text = "Teleport"
TeleportTab.BackgroundColor3 = Color3.fromRGB(100, 170, 100) -- aktif default
TeleportTab.TextColor3 = Color3.new(1,1,1)

local MuteTab = Instance.new("TextButton", TabFrame)
MuteTab.Size = UDim2.new(0.33, 0, 1, 0)
MuteTab.Position = UDim2.new(0.33, 0, 0, 0)
MuteTab.Text = "Mute"
MuteTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MuteTab.TextColor3 = Color3.new(1,1,1)

local SpeedTab = Instance.new("TextButton", TabFrame)
SpeedTab.Size = UDim2.new(0.34, 0, 1, 0)
SpeedTab.Position = UDim2.new(0.66, 0, 0, 0)
SpeedTab.Text = "Speed"
SpeedTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedTab.TextColor3 = Color3.new(1,1,1)

-- Player list
local PlayerList = Instance.new("ScrollingFrame", MainFrame)
PlayerList.Size = UDim2.new(1, 0, 1, -95)
PlayerList.Position = UDim2.new(0, 0, 0, 65)
PlayerList.BackgroundTransparency = 1
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout", PlayerList)
UIList.Padding = UDim.new(0, 4)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y + 10)
end)

-- Speed settings
local SpeedFrame = Instance.new("Frame", MainFrame)
SpeedFrame.Size = UDim2.new(1, -20, 0, 80)
SpeedFrame.Position = UDim2.new(0, 10, 0, 65)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedFrame.Visible = false
Instance.new("UICorner", SpeedFrame).CornerRadius = UDim.new(0, 10)

local ToggleBtn = Instance.new("TextButton", SpeedFrame)
ToggleBtn.Size = UDim2.new(1, -20, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "Speed: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

local SpeedBox = Instance.new("TextBox", SpeedFrame)
SpeedBox.Size = UDim2.new(1, -20, 0, 30)
SpeedBox.Position = UDim2.new(0, 10, 0, 45)
SpeedBox.PlaceholderText = "Set Speed"
SpeedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 6)

-- Icon
local IconBtn = Instance.new("TextButton", ScreenGui)
IconBtn.Size = UDim2.new(0, 40, 0, 40)
IconBtn.Position = UDim2.new(0, 20, 0.5, -20)
IconBtn.Text = "TP"
IconBtn.TextColor3 = Color3.new(1,1,1)
IconBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
IconBtn.Visible = false
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)

-- Refresh players
local function refresh(mode)
    currentMode = mode
    for _, child in ipairs(PlayerList:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local Btn = Instance.new("TextButton", PlayerList)
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.Text = "  " .. plr.Name
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Btn.TextColor3 = Color3.fromRGB(0, 255, 0)
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.LayoutOrder = #PlayerList:GetChildren()

            Btn.MouseButton1Click:Connect(function()
                if mode == "Teleport" then
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
                    end
                elseif mode == "Mute" then
                    if mutedPlayers[plr.Name] then
                        mutedPlayers[plr.Name] = nil
                        Btn.Text = "  " .. plr.Name
                    else
                        mutedPlayers[plr.Name] = true
                        Btn.Text = "  " .. plr.Name .. " (Muted)"
                    end
                end
            end)
        end
    end
end

-- Tab highlight function
local function setActiveTab(tab)
    TeleportTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    MuteTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    SpeedTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    tab.BackgroundColor3 = Color3.fromRGB(100, 170, 100)
end

TeleportTab.MouseButton1Click:Connect(function()
    PlayerList.Visible = true
    SpeedFrame.Visible = false
    setActiveTab(TeleportTab)
    refresh("Teleport")
end)

MuteTab.MouseButton1Click:Connect(function()
    PlayerList.Visible = true
    SpeedFrame.Visible = false
    setActiveTab(MuteTab)
    refresh("Mute")
end)

SpeedTab.MouseButton1Click:Connect(function()
    PlayerList.Visible = false
    SpeedFrame.Visible = true
    setActiveTab(SpeedTab)
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IconBtn.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    IconBtn.Visible = false
end)

-- Drag function
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(MainFrame)
makeDraggable(IconBtn)

-- Chat mute
local ChatEvents = game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
if ChatEvents then
    local OnMessage = ChatEvents:FindFirstChild("OnMessageDoneFiltering")
    if OnMessage then
        OnMessage.OnClientEvent:Connect(function(data)
            if mutedPlayers[data.FromSpeaker] then
                data.Message = ""
            end
        end)
    end
end

-- Speed hack
ToggleBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    ToggleBtn.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
    if not speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

SpeedBox.FocusLost:Connect(function()
    local val = tonumber(SpeedBox.Text)
    if val and val > 0 then
        speedValue = val
    end
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if speedEnabled then
            if hum.WalkSpeed ~= speedValue then
                hum.WalkSpeed = speedValue
            end
        else
            if hum.WalkSpeed ~= 16 then
                hum.WalkSpeed = 16
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    if not speedEnabled then
        hum.WalkSpeed = 16
    end
end)

-- Auto refresh saat ada player join/leave
Players.PlayerAdded:Connect(function()
    if PlayerList.Visible then
        refresh(currentMode)
    end
end)

Players.PlayerRemoving:Connect(function()
    if PlayerList.Visible then
        refresh(currentMode)
    end
end)

refresh("Teleport")