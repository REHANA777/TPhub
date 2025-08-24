local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local mutedPlayers = {}

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.ResetOnSpawn = false

-- Main GUI
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.3

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

-- Title bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 12)

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
TeleportTab.Size = UDim2.new(0.5, 0, 1, 0)
TeleportTab.Text = "Teleport"
TeleportTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TeleportTab.TextColor3 = Color3.new(1,1,1)

local MuteTab = Instance.new("TextButton", TabFrame)
MuteTab.Size = UDim2.new(0.5, 0, 1, 0)
MuteTab.Position = UDim2.new(0.5, 0, 0, 0)
MuteTab.Text = "Mute"
MuteTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MuteTab.TextColor3 = Color3.new(1,1,1)

-- Player list
local PlayerList = Instance.new("ScrollingFrame", MainFrame)
PlayerList.Size = UDim2.new(1, 0, 1, -65)
PlayerList.Position = UDim2.new(0, 0, 0, 65)
PlayerList.BackgroundTransparency = 1
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout", PlayerList)
UIList.Padding = UDim.new(0, 4)

-- Icon
local IconBtn = Instance.new("TextButton", ScreenGui)
IconBtn.Size = UDim2.new(0, 55, 0, 55)
IconBtn.Position = UDim2.new(0, 20, 0.5, -25)
IconBtn.Text = "TP"
IconBtn.TextColor3 = Color3.new(1,1,1)
IconBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
IconBtn.Visible = false

local IconCorner = Instance.new("UICorner", IconBtn)
IconCorner.CornerRadius = UDim.new(1, 0)

-- Refresh players
local function refresh(mode)
    PlayerList:ClearAllChildren()
    local layout = UIList:Clone()
    layout.Parent = PlayerList
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local Btn = Instance.new("TextButton", PlayerList)
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.Text = plr.Name
            Btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.MouseButton1Click:Connect(function()
                if mode == "Teleport" then
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
                    end
                elseif mode == "Mute" then
                    if mutedPlayers[plr.Name] then
                        mutedPlayers[plr.Name] = nil
                        Btn.Text = plr.Name
                    else
                        mutedPlayers[plr.Name] = true
                        Btn.Text = plr.Name.." (Muted)"
                    end
                end
            end)
        end
    end
    PlayerList.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y+10)
end

TeleportTab.MouseButton1Click:Connect(function()
    refresh("Teleport")
end)

MuteTab.MouseButton1Click:Connect(function()
    refresh("Mute")
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

refresh("Teleport")