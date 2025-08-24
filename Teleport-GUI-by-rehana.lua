local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local mutedPlayers = {}

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(1, 0, 0, 30)
TabFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
local UICorner2 = Instance.new("UICorner", TabFrame)
UICorner2.CornerRadius = UDim.new(0, 12)

local TeleportButton = Instance.new("TextButton", TabFrame)
TeleportButton.Size = UDim2.new(0.5, 0, 1, 0)
TeleportButton.Text = "Teleport"
TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportButton.TextColor3 = Color3.new(1, 1, 1)

local MuteButton = Instance.new("TextButton", TabFrame)
MuteButton.Size = UDim2.new(0.5, 0, 1, 0)
MuteButton.Position = UDim2.new(0.5, 0, 0, 0)
MuteButton.Text = "Mute"
MuteButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MuteButton.TextColor3 = Color3.new(1, 1, 1)

local PlayerList = Instance.new("ScrollingFrame", MainFrame)
PlayerList.Size = UDim2.new(1, 0, 1, -30)
PlayerList.Position = UDim2.new(0, 0, 0, 30)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ScrollBarThickness = 4
PlayerList.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", PlayerList)
UIListLayout.Padding = UDim.new(0, 4)

local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)

local IconButton = Instance.new("TextButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0, 20, 0.5, -25)
IconButton.Text = "TP gui"
IconButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
IconButton.TextColor3 = Color3.new(1, 1, 1)
IconButton.Visible = false
IconButton.AutoButtonColor = true

local function refreshPlayers(mode)
    PlayerList:ClearAllChildren()
    local layout = UIListLayout:Clone()
    layout.Parent = PlayerList
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local Btn = Instance.new("TextButton", PlayerList)
            Btn.Size = UDim2.new(1, -5, 0, 30)
            Btn.TextColor3 = Color3.new(1, 1, 1)
            Btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            Btn.Text = player.Name
            Btn.MouseButton1Click:Connect(function()
                if mode == "Teleport" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(0,2,0))
                elseif mode == "Mute" then
                    if mutedPlayers[player.Name] then
                        mutedPlayers[player.Name] = nil
                        Btn.Text = player.Name
                    else
                        mutedPlayers[player.Name] = true
                        Btn.Text = player.Name .. " (Muted)"
                    end
                end
            end)
        end
    end
    PlayerList.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y+10)
end

TeleportButton.MouseButton1Click:Connect(function()
    refreshPlayers("Teleport")
end)

MuteButton.MouseButton1Click:Connect(function()
    refreshPlayers("Mute")
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IconButton.Visible = true
end)

IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    IconButton.Visible = false
end)

local ChatEvents = game.ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents",10)
if ChatEvents then
    local OnMessage = ChatEvents:WaitForChild("OnMessageDoneFiltering",10)
    if OnMessage then
        OnMessage.OnClientEvent:Connect(function(data)
            if mutedPlayers[data.FromSpeaker] then
                data.Message = ""
            end
        end)
    end
end

refreshPlayers("Teleport")