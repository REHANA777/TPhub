-- JALANKAN DI EXECUTOR DELTA ANDA
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ChatService = game:GetService("Chat")

local lPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local targetParent = CoreGui:FindFirstChild("RobloxGui") or CoreGui

-- Bersihkan UI lama jika duplikat
if targetParent:FindFirstChild("StewartConsoleGui") then
	targetParent["StewartConsoleGui"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StewartConsoleGui"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = targetParent

-- CONFIGURATION & TRACKING SYSTEM
local noclipConnection = nil
local originalCameraSubject = nil
local deadPlayersTracking = {}

local shockPhrases = {
	"lah kok gw mati ??",
	"hah kok mati?",
	"report pake sc cik",
	"p",
	"Sc jir",
	"cit kah??",
	"LAH",
	"lah kok mati?",
	"apaan ini jir",
	"eh?",
	"lah ngebug kah???"
}

-- =============================================================================
-- FLOATING BUTTON TO TOGGLE
-- =============================================================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
ToggleBtn.Text = "CMD"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.Font = Enum.Font.RobotoMono
ToggleBtn.TextSize = 14
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = ToggleBtn

-- DRAG BUTTON
local btnDragging = false
local btnDragStart
local btnStartPos

ToggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		btnDragging = true
		btnDragStart = input.Position
		btnStartPos = ToggleBtn.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				btnDragging = false
			end
		end)
	end
end)

ToggleBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if btnDragging then
			local delta = input.Position - btnDragStart
			ToggleBtn.Position = UDim2.new(
				btnStartPos.X.Scale,
				btnStartPos.X.Offset + delta.X,
				btnStartPos.Y.Scale,
				btnStartPos.Y.Offset + delta.Y
			)
		end
	end
end)

-- =============================================================================
-- MAIN CONSOLE SCREEN
-- =============================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 280)
MainFrame.Position = UDim2.new(0.5, -240, 0.4, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -40, 0, 25)
HeaderLabel.Position = UDim2.new(0, 12, 0, 8)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = '"Cmdr"="Client": StewartTristan5>='
HeaderLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Font = Enum.Font.RobotoMono
HeaderLabel.TextSize = 13
HeaderLabel.Parent = MainFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -24, 0, 35)
TextBox.Position = UDim2.new(0, 12, 1, -47)
TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TextBox.TextColor3 = Color3.fromRGB(0, 255, 120)
TextBox.Font = Enum.Font.RobotoMono
TextBox.TextSize = 13
TextBox.Text = ""
TextBox.PlaceholderText = "Ketik command di sini... (Contoh: /command)"
TextBox.PlaceholderColor3 = Color3.fromRGB(0, 100, 50)
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.Parent = MainFrame

local TextCorner = Instance.new("UICorner")
TextCorner.CornerRadius = UDim.new(0, 5)
TextCorner.Parent = TextBox

local LogArea = Instance.new("ScrollingFrame")
LogArea.Size = UDim2.new(1, -24, 1, -100)
LogArea.Position = UDim2.new(0, 12, 0, 40)
LogArea.BackgroundTransparency = 1
LogArea.CanvasSize = UDim2.new(0, 0, 10, 0)
LogArea.ScrollBarThickness = 3
LogArea.Parent = MainFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 4)
LogLayout.Parent = LogArea

local function printToConsole(text, color)
	color = color or Color3.fromRGB(0, 255, 120)

	local log = Instance.new("TextLabel")
	log.Size = UDim2.new(1, 0, 0, 18)
	log.BackgroundTransparency = 1
	log.Text = text
	log.TextColor3 = color
	log.Font = Enum.Font.RobotoMono
	log.TextSize = 12
	log.TextXAlignment = Enum.TextXAlignment.Left
	log.Parent = LogArea

	LogArea.CanvasSize = UDim2.new(0,0,0,LogLayout.AbsoluteContentSize.Y + 20)
	LogArea.CanvasPosition = Vector2.new(0, LogArea.CanvasSize.Y.Offset)
end

-- LOADING SYSTEM EFFECT
local LoadingOverlay = Instance.new("Frame")
LoadingOverlay.Size = UDim2.new(1, 0, 1, 0)
LoadingOverlay.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LoadingOverlay.ZIndex = 5
LoadingOverlay.Parent = MainFrame

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(1, 0, 1, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "loading console..."
LoadingLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
LoadingLabel.Font = Enum.Font.RobotoMono
LoadingLabel.TextSize = 16
LoadingLabel.ZIndex = 6
LoadingLabel.Parent = LoadingOverlay

task.spawn(function()
	task.wait(1.2)
	LoadingLabel.Text = "SYSTEMS ONLINE. ACCESS GRANTED."
	task.wait(0.6)
	LoadingOverlay:Destroy()
	printToConsole("[SYSTEM]: Welcome back, StewartTristan5. Type /command.", Color3.fromRGB(0,255,255))
end)

-- DRAGGABLE ENGINE
local dragToggle, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if UserInputService:GetFocusedTextBox() == nil then
			dragToggle = true
			dragStart = input.Position
			startPos = MainFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragToggle then
			updateInput(input)
		end
	end
end)

local function findTarget(name)
	if name == "me" or name == "" then
		return lPlayer
	end

	for _, p in pairs(Players:GetPlayers()) do
		if p.Name:lower():sub(1, #name) == name:lower() then
			return p
		end
	end

	return nil
end

local function triggerShockBubble(targetPlayer)
	task.spawn(function()
		local randomPhrase = shockPhrases[math.random(1, #shockPhrases)]

		local char = targetPlayer.Character
		local head = char and char:FindFirstChild("Head")

		if head then
			ChatService:Chat(head, randomPhrase, Enum.ChatColor.White)
		end
	end)
end

local function monitorAndRetrack(targetPlayer)
	if targetPlayer == lPlayer then return end

	local char = targetPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if root then
		deadPlayersTracking[targetPlayer.Name] = root.Position
	end

	local connection

	connection = targetPlayer.CharacterAdded:Connect(function(newChar)
		local savedPos = deadPlayersTracking[targetPlayer.Name]

		if savedPos then
			local hum = newChar:WaitForChild("Humanoid", 5)

			if hum then
				task.wait(0.5)
				hum:MoveTo(savedPos)

				printToConsole("[RETRACT]: "..targetPlayer.Name.." otomatis berjalan kembali.")

				deadPlayersTracking[targetPlayer.Name] = nil
				connection:Disconnect()
			end
		else
			connection:Disconnect()
		end
	end)
end

-- =============================================================================
-- COMMAND ENGINE
-- =============================================================================
local function executeCommand(fullText)
	if fullText:sub(1,1) ~= "/" then return end

	printToConsole("> "..fullText, Color3.fromRGB(150,150,150))

	local args = {}
	for word in fullText:gmatch("%S+") do
		table.insert(args, word)
	end

	local cmd = args[1]:lower()
	local targetNameArg = args[2] or ""

	-- COMMAND LIST
	if cmd == "/command" then
		printToConsole("--- LIST COMMAND ---", Color3.fromRGB(255,255,0))
		printToConsole("/copycoordinat")
		printToConsole("/tp [nama]")
		printToConsole("/kill [nama]")
		printToConsole("/ban [nama]")
		printToConsole("/kick [nama]")
		printToConsole("/bchat [nama] say [teks]")
		printToConsole("/gtool [nama_tool]")
		printToConsole("/gtptool")
		printToConsole("/view [nama]")
		printToConsole("/skybox [id]")
		printToConsole("/noclip")
		printToConsole("/unoclip")
		printToConsole("/headless")
		printToConsole("/listplayer")
		printToConsole("/speed [jumlah/normal]")
	end

	-- COPY COORD
	if cmd == "/copycoordinat" then
		if lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local pos = lPlayer.Character.HumanoidRootPart.Position
			local strPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)

			if setclipboard then
				setclipboard(strPos)
			end

			printToConsole("[SUCCESS]: Koordinat disalin!")
		end
	end

	-- TP
	if cmd == "/tp" then
		local target = findTarget(targetNameArg)

		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
			lPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
			printToConsole("[SUCCESS]: Teleport ke "..target.Name)
		end
	end

	
-- KILL
if cmd == "/kill" then
	local target = findTarget(targetNameArg)

	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		local char = target.Character
		local hum = char:FindFirstChild("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")

		if hum and root then
			-- simpan posisi mati
			local deathPos = root.Position

			-- shock fake
			triggerShockBubble(target)

			-- bikin keliatan mati di client lu
			hum.BreakJointsOnDeath = true
			hum.Health = 0

			printToConsole("[SUCCESS]: "..target.Name.." eliminated.")

			-- tunggu respawn
			local respawnConn
			respawnConn = target.CharacterAdded:Connect(function(newChar)
				local newHum = newChar:WaitForChild("Humanoid", 5)
				local newRoot = newChar:WaitForChild("HumanoidRootPart", 5)

				if newHum and newRoot then
					task.wait(1)

					-- teleport ke posisi mati
					newRoot.CFrame = CFrame.new(deathPos + Vector3.new(0,3,0))

					-- jalan dikit biar keliatan natural
					newHum:MoveTo(deathPos)

					printToConsole("[RETRACT]: "..target.Name.." kembali ke lokasi kematian.")

					respawnConn:Disconnect()
				end
			end)
		end
	end
end

	-- BAN
	if cmd == "/ban" then
		local target = findTarget(targetNameArg)

		if target and target ~= lPlayer then
			target:Kick("You have been banned by StewartTristan5")
			printToConsole("[SUCCESS]: "..target.Name.." berhasil diban.")
		end
	end

	-- KICK
	if cmd == "/kick" then
		local target = findTarget(targetNameArg)

		if target and target ~= lPlayer then
			target:Kick("Kicked by StewartTristan5")
			printToConsole("[SUCCESS]: "..target.Name.." berhasil dikick.")
		end
	end

	-- BCHAT
	if cmd == "/bchat" then
		local target = findTarget(targetNameArg)

		local sayIdx = 0

		for i,v in ipairs(args) do
			if v:lower() == "say" then
				sayIdx = i
				break
			end
		end

		if target and sayIdx > 0 and args[sayIdx+1] then
			local msgTable = {}

			for i = sayIdx+1, #args do
				table.insert(msgTable, args[i])
			end

			local textMsg = table.concat(msgTable, " ")

			local head = target.Character and target.Character:FindFirstChild("Head")

			if head then
				ChatService:Chat(head, textMsg, Enum.ChatColor.White)
				printToConsole("[SUCCESS]: Memaksa Chat -> "..target.Name)
			end
		end
	end

	-- GTOOL
	if cmd == "/gtool" then
		local toolName = targetNameArg

		if lPlayer.Character and toolName ~= "" then
			local Tool = Instance.new("Tool")
			Tool.Name = toolName
			Tool.RequiresHandle = true

			local Handle = Instance.new("Part")
			Handle.Name = "Handle"
			Handle.Size = Vector3.new(1,1,1)
			Handle.Parent = Tool

			-- MAGIC CARPET FIX
			if toolName:lower() == "magiccarpet" then
				local flyConnection

				Tool.Equipped:Connect(function()
					flyConnection = RunService.Heartbeat:Connect(function()
						if lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
							local hrp = lPlayer.Character.HumanoidRootPart
							local moveDir = lPlayer.Character.Humanoid.MoveDirection

							hrp.Velocity = Vector3.new(
								moveDir.X * 70,
								0,
								moveDir.Z * 70
							)

							if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
								hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
							end
						end
					end)
				end)

				Tool.Unequipped:Connect(function()
					if flyConnection then
						flyConnection:Disconnect()
						flyConnection = nil
					end
				end)

			elseif toolName:lower() == "speedcoil" then
				Tool.Equipped:Connect(function()
					lPlayer.Character.Humanoid.WalkSpeed = 35
				end)

				Tool.Unequipped:Connect(function()
					lPlayer.Character.Humanoid.WalkSpeed = 16
				end)

			elseif toolName:lower() == "gravitycoil" then
				Tool.Equipped:Connect(function()
					workspace.Gravity = 45
				end)

				Tool.Unequipped:Connect(function()
					workspace.Gravity = 196.2
				end)

			else
				Tool.Activated:Connect(function()
					local ray = workspace.CurrentCamera:ViewportPointToRay(
						UserInputService:GetMouseLocation().X,
						UserInputService:GetMouseLocation().Y
					)

					local result = workspace:Raycast(ray.Origin, ray.Direction * 400)

					if result and result.Instance and result.Instance.Parent then
						local hitModel = result.Instance.Parent
						local hum = hitModel:FindFirstChild("Humanoid")

						if hum and hitModel.Name ~= lPlayer.Name then
							local targetPlayerObj = Players:GetPlayerFromCharacter(hitModel)

							if targetPlayerObj then
								monitorAndRetrack(targetPlayerObj)
								triggerShockBubble(targetPlayerObj)
							end

							task.wait(0.05)

							hum.Health = 0

							printToConsole("[SUCCESS]: Target tereliminasi -> "..hitModel.Name)
						end
					end
				end)
			end

			Tool.Parent = lPlayer.Backpack

			printToConsole("[SUCCESS]: Menambahkan senjata -> "..toolName)
		end
	end

	-- GTP TOOL
	if cmd == "/gtptool" then
		local tpTool = Instance.new("Tool")
		tpTool.Name = "UltraFastTpTool"
		tpTool.RequiresHandle = false

		tpTool.Activated:Connect(function()
			local unitRay = workspace.CurrentCamera:ViewportPointToRay(
				UserInputService:GetMouseLocation().X,
				UserInputService:GetMouseLocation().Y
			)

			local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000)

			if result and lPlayer.Character and lPlayer.Character:FindFirstChild("HumanoidRootPart") then
				TweenService:Create(
					lPlayer.Character.HumanoidRootPart,
					TweenInfo.new(0.12),
					{
						CFrame = CFrame.new(result.Position + Vector3.new(0,3,0))
					}
				):Play()
			end
		end)

		tpTool.Parent = lPlayer.Backpack

		printToConsole("[SUCCESS]: Ultra Fast Teleport Tool aktif")
	end

	-- VIEW
	if cmd == "/view" then
		local target = findTarget(targetNameArg)

		if target and target.Character and target.Character:FindFirstChild("Humanoid") then
			if not originalCameraSubject then
				originalCameraSubject = workspace.CurrentCamera.CameraSubject
			end

			workspace.CurrentCamera.CameraSubject = target.Character.Humanoid

			printToConsole("[SUCCESS]: Mengunci pandangan kamera ke "..target.Name)

		elseif targetNameArg == "me" and originalCameraSubject then
			workspace.CurrentCamera.CameraSubject = lPlayer.Character.Humanoid

			printToConsole("[SUCCESS]: Kamera kembali normal.")
		end
	end

	-- SKYBOX
	if cmd == "/skybox" then
		local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)

		local id = "rbxassetid://"..targetNameArg

		sky.SkyboxBk = id
		sky.SkyboxDn = id
		sky.SkyboxFt = id
		sky.SkyboxLf = id
		sky.SkyboxRt = id
		sky.SkyboxUp = id

		printToConsole("[SUCCESS]: Atmosfer Skybox berhasil diperbarui")
	end

	-- NOCLIP
	if cmd == "/noclip" then
		if not noclipConnection then
			noclipConnection = RunService.Stepped:Connect(function()
				if lPlayer.Character then
					for _, c in pairs(lPlayer.Character:GetDescendants()) do
						if c:IsA("BasePart") then
							c.CanCollide = false
						end
					end
				end
			end)

			printToConsole("[SUCCESS]: Fitur Noclip diaktifkan")
		end
	end

	-- UNOCLIP
	if cmd == "/unoclip" then
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil

			printToConsole("[SUCCESS]: Fitur Noclip dinonaktifkan", Color3.fromRGB(255,50,50))
		end
	end

	-- HEADLESS
	if cmd == "/headless" then
		if lPlayer.Character and lPlayer.Character:FindFirstChild("Head") then
			lPlayer.Character.Head.Transparency = 1

			for _,v in pairs(lPlayer.Character.Head:GetChildren()) do
				if v:IsA("Decal") then
					v.Transparency = 1
				end
			end

			printToConsole("[SUCCESS]: Headless aktif")
		end
	end

	-- LISTPLAYER
	if cmd == "/listplayer" then
		printToConsole("--- PLAYER LIST ---", Color3.fromRGB(255,255,0))

		for _,plr in pairs(Players:GetPlayers()) do
			printToConsole(plr.Name, Color3.fromRGB(0,255,120))
		end
	end

	-- SPEED
	if cmd == "/speed" then
		if lPlayer.Character and lPlayer.Character:FindFirstChild("Humanoid") then
			local hum = lPlayer.Character.Humanoid

			if targetNameArg == "normal" then
				hum.WalkSpeed = 16
				printToConsole("[SUCCESS]: Speed normal")
			else
				local num = tonumber(targetNameArg)

				if num then
					hum.WalkSpeed = num
					printToConsole("[SUCCESS]: Speed diubah jadi "..num)
				end
			end
		end
	end
end

TextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and TextBox.Text ~= "" then
		executeCommand(TextBox.Text)
		TextBox.Text = ""
	end
end)

pas mati itu yg r15 g bisa killnyap g kereset+ kalo bisa abis mati dan respawn itu darahnya di fullin lagi jadi keliatan persis kayak respawn trus jalan ke posisi sebelum nya si targetParent mati , bikin full sctambahin command /textcolor "warna" ganti warna berbagai warna contoh green red blue dll,/guicolor "warna" , sama kayak yg ganti warna text cuman inj guinya warnanya diganti , + sistem command not found kalo command g ad + player not found kalo menggunakan command yg membutuhkan target tapi tidak ada target itu, bikin full sc modif itu , dan jangan yg lain

kes sistem di bagian load gui , key=xyz67 
