-- LocalScript: Умная летающая ПЛАТФОРМА (без улетания!)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- уишечка 
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Name = "FlyingPlatformUI"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "4RM-Project"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

local recreateBtn = Instance.new("TextButton")
recreateBtn.Text = "Создать"
recreateBtn.Size = UDim2.new(1, -10, 0, 30)
recreateBtn.Position = UDim2.new(0, 5, 0, 40)
recreateBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
recreateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
recreateBtn.Parent = frame

local scaleUpBtn = Instance.new("TextButton")
scaleUpBtn.Text = "+ Размер"
scaleUpBtn.Size = UDim2.new(0.5, -7, 0, 30)
scaleUpBtn.Position = UDim2.new(0, 5, 0, 80)
scaleUpBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
scaleUpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleUpBtn.Parent = frame

local scaleDownBtn = Instance.new("TextButton")
scaleDownBtn.Text = "- Размер"
scaleDownBtn.Size = UDim2.new(0.5, -7, 0, 30)
scaleDownBtn.Position = UDim2.new(0.5, 7, 0, 80)
scaleDownBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
scaleDownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleDownBtn.Parent = frame

local autoModeBtn = Instance.new("TextButton")
autoModeBtn.Text = "Авто: ВЫКЛ"
autoModeBtn.Size = UDim2.new(1, -10, 0, 30)
autoModeBtn.Position = UDim2.new(0, 5, 0, 120)
autoModeBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
autoModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoModeBtn.Parent = frame

local deleteBtn = Instance.new("TextButton")
deleteBtn.Text = "УДАЛИТЬ"
deleteBtn.Size = UDim2.new(1, -10, 0, 30)
deleteBtn.Position = UDim2.new(0, 5, 0, 160)
deleteBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
deleteBtn.Parent = frame

screenGui.Parent = Player:WaitForChild("PlayerGui")

-- Переменные (я сам вахуи)
local platform = nil
local isDragging = false
local dragDepth = 0
local targetPosition = nil
local isAutoMode = false

-- Создание ПЛАТФОРМЫ
local function createPlatform()
	if platform and platform.Parent then
		platform:Destroy()
	end

	local char = Player.Character or Player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	platform = Instance.new("Part")
	platform.Name = "FlyingPlatform"
	platform.Size = Vector3.new(6, 0.5, 6) -- плоская платформа
	platform.Position = hrp.Position + Vector3.new(0, -3.5, 5) -- вперёд и ВНИЗ!
	platform.Color = Color3.fromRGB(100, 200, 255)
	platform.Material = Enum.Material.Neon
	platform.Anchored = true
	platform.CanCollide = true
	platform.Parent = Workspace
end

-- Удаление
local function deleteEverything()
	if platform and platform.Parent then
		platform:Destroy()
	end
	platform = nil
	isDragging = false
	targetPosition = nil
	isAutoMode = false
	autoModeBtn.Text = "Авто: ВЫКЛ"
end

-- Управление мышью (только в ручном режиме)
local mouse = Player:GetMouse()

local function onMouseClick()
	if not platform or isAutoMode then return end
	local cam = Workspace.CurrentCamera
	if not cam then return end

	local ray = Ray.new(mouse.Origin.p, mouse.Origin.lookVector * 1000)
	local hitPart, hitPos = Workspace:FindPartOnRayWithWhitelist(ray, {platform})
	if hitPart == platform then
		isDragging = true
		dragDepth = (hitPos - cam.CFrame.Position).Magnitude
		targetPosition = platform.Position
	end
end

local function onMouseMove()
	if not isDragging or not platform or isAutoMode then return end
	local cam = Workspace.CurrentCamera
	if not cam then return end

	local unitRay = cam:ScreenPointToRay(mouse.X, mouse.Y)
	local targetPos = cam.CFrame.Position + unitRay.Direction * dragDepth
	targetPosition = targetPos
end

local function onMouseRelease()
	isDragging = false
	targetPosition = nil
end

-- 🧲 АВТО-РЕЖИМ: Платформа СЛЕДУЕТ, но НЕ ТОЛКАЕТ
RunService.RenderStepped:Connect(function()
	if not platform then return end

	if isAutoMode then
		local char = Player.Character
		if not char then return end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		-- ВПЕРЁД на 1.2, ВНИЗ на 3.5 от hrp — НИЖЕ стоп!
		local forwardOffset = hrp.CFrame.LookVector * 1.2
		local targetPos = hrp.Position + Vector3.new(forwardOffset.X, -3.5, forwardOffset.Z)

		-- Плавность 0.25 — быстро, но без рывков
		platform.Position = platform.Position:Lerp(targetPos, 0.25)
	else
		-- Ручной режим
		if isDragging and targetPosition then
			platform.Position = platform.Position:Lerp(targetPosition, 0.2)
		end
	end
end)

-- Переключение авто-режима
autoModeBtn.MouseButton1Click:Connect(function()
	isAutoMode = not isAutoMode
	autoModeBtn.Text = isAutoMode and "Авто: ВКЛ ✅" or "Авто: ВЫКЛ"
	if isAutoMode then
		isDragging = false
		targetPosition = nil
	end
end)

-- Подключение мыши
mouse.Button1Down:Connect(onMouseClick)
mouse.Move:Connect(onMouseMove)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		onMouseRelease()
	end
end)

-- UI события
recreateBtn.MouseButton1Click:Connect(createPlatform)
deleteBtn.MouseButton1Click:Connect(deleteEverything)
scaleUpBtn.MouseButton1Click:Connect(function()
	if platform then platform.Size = platform.Size * 1.2 end
end)
scaleDownBtn.MouseButton1Click:Connect(function()
	if platform then platform.Size = platform.Size * 0.8 end
end)

-- Создаём платформу при старте
createPlatform()
