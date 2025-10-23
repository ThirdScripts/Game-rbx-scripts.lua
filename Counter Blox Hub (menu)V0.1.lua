-- Загрузка библиотеки UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GertiScriptsBlox", "Ocean")

-- Создание вкладок и секций
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Main")

-- Настройки FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = 200
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false

-- Функция для аимбота
Section:NewButton("Aimbot(PressT)", "ButtonInfo", function()
    local camera = workspace.CurrentCamera
    local players = game:GetService("Players")
    local user = players.LocalPlayer
    local inputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")

    local predictionFactor = 0.042
    local aimSpeed = 10
    local holding = false
    local aimBotEnabled = false

    local function isSameTeam(player)
        if player.Team and user.Team then
            return player.Team == user.Team
        end
        return false
    end

    local function getClosestPlayer()
        local closest, minDist = nil, math.huge
        for _, player in pairs(players:GetPlayers()) do
            if player ~= user and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not isSameTeam(player) then
                local head = player.Character:FindFirstChild("Head")
                local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - inputService:GetMouseLocation()).Magnitude
                if onScreen and distance <= FOVCircle.Radius and distance < minDist then
                    closest, minDist = player, distance
                end
            end
        end
        return closest
    end

    local function predictHead(target)
        local head = target.Character.Head
        local velocity = target.Character.HumanoidRootPart.AssemblyLinearVelocity or Vector3.zero
        return head.Position + velocity * predictionFactor
    end

    inputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then holding = true end
        if input.KeyCode == Enum.KeyCode.T then
            aimBotEnabled = not aimBotEnabled
            FOVCircle.Visible = aimBotEnabled
            if not aimBotEnabled then holding = false end
        end
    end)

    inputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then holding = false end
    end)

    runService.RenderStepped:Connect(function()
        if not aimBotEnabled then return end
        FOVCircle.Position = inputService:GetMouseLocation()
        if holding then
            local target = getClosestPlayer()
            if target then
                local predicted = predictHead(target)
                camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, predicted), aimSpeed * 0.1)
            end
        end
    end)
end)

-- Спидхак
Section:NewTextBox("Speedhack(PressX)", "TextboxInfo", function(txt)
    local speed = tonumber(txt) or 100
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local userInputService = game:GetService("UserInputService")
    local bodyVelocity

    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.X then
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * speed
                bodyVelocity.Parent = humanoidRootPart
            else
                bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * speed
            end
        end
    end)

    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.X then
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end)
end)

-- Фулбрайт
Section:NewToggle("Fullbright", "ToggleInfo", function(state)
    local Lighting = game:GetService("Lighting")
    if state then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.FogEnd = 1e10
    else
        Lighting.Ambient = Color3.new(0.7, 0.7, 0.7)
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.7)
        Lighting.FogEnd = 100000
    end
end)

-- ESP
Section:NewButton("ESP", "ButtonInfo", function()
    -- Settings
local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Box_Thickness = 2,
    Team_Check = true,  -- Включаем проверку команды
    Team_Color = true,  -- Использовать цвет команды
    Autothickness = true
}

-- Locals
local Space = game:GetService("Workspace")
local Player = game:GetService("Players").LocalPlayer
local Camera = Space.CurrentCamera

-- Locals
local function NewLine(color, thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Vis(lib, state)
    for i, v in pairs(lib) do
        v.Visible = state
    end
end

local function Colorize(lib, color)
    for i, v in pairs(lib) do
        v.Color = color
    end
end

local Black = Color3.fromRGB(0, 0, 0)

local function Rainbow(lib, delay)
    for hue = 0, 1, 1/30 do
        local color = Color3.fromHSV(hue, 0.6, 1)
        Colorize(lib, color)
        wait(delay)
    end
    Rainbow(lib)
end

-- Main Draw Function
local function Main(plr)
    repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil
    local R15
    if plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
        R15 = true
    else 
        R15 = false
    end
    local Library = {
        TL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        TL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        TR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        TR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        BL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        BL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        BR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        BR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness)
    }
    coroutine.wrap(Rainbow)(Library, 0.15)
    local oripart = Instance.new("Part")
    oripart.Parent = Space
    oripart.Transparency = 1
    oripart.CanCollide = false
    oripart.Size = Vector3.new(1, 1, 1)
    oripart.Position = Vector3.new(0, 0, 0)

    -- Updater Loop
    local function Updater()
        local c 
        c = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local Hum = plr.Character
                local HumPos, vis = Camera:WorldToViewportPoint(Hum.HumanoidRootPart.Position)
                if vis then
                    oripart.Size = Vector3.new(Hum.HumanoidRootPart.Size.X, Hum.HumanoidRootPart.Size.Y*1.5, Hum.HumanoidRootPart.Size.Z)
                    oripart.CFrame = CFrame.new(Hum.HumanoidRootPart.CFrame.Position, Camera.CFrame.Position)
                    local SizeX = oripart.Size.X
                    local SizeY = oripart.Size.Y
                    local TL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, SizeY, 0)).p)
                    local TR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, SizeY, 0)).p)
                    local BL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, -SizeY, 0)).p)
                    local BR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, -SizeY, 0)).p)

                    -- Используем цвет команды игрока, если активирована настройка Team_Color
                    if Settings.Team_Color and plr.TeamColor then
                        Colorize(Library, plr.TeamColor.Color)
                    end

                    local ratio = (Camera.CFrame.p - Hum.HumanoidRootPart.Position).magnitude
                    local offset = math.clamp(1/ratio*750, 2, 300)

                    Library.TL1.From = Vector2.new(TL.X, TL.Y)
                    Library.TL1.To = Vector2.new(TL.X + offset, TL.Y)
                    Library.TL2.From = Vector2.new(TL.X, TL.Y)
                    Library.TL2.To = Vector2.new(TL.X, TL.Y + offset)

                    Library.TR1.From = Vector2.new(TR.X, TR.Y)
                    Library.TR1.To = Vector2.new(TR.X - offset, TR.Y)
                    Library.TR2.From = Vector2.new(TR.X, TR.Y)
                    Library.TR2.To = Vector2.new(TR.X, TR.Y + offset)

                    Library.BL1.From = Vector2.new(BL.X, BL.Y)
                    Library.BL1.To = Vector2.new(BL.X + offset, BL.Y)
                    Library.BL2.From = Vector2.new(BL.X, BL.Y)
                    Library.BL2.To = Vector2.new(BL.X, BL.Y - offset)

                    Library.BR1.From = Vector2.new(BR.X, BR.Y)
                    Library.BR1.To = Vector2.new(BR.X - offset, BR.Y)
                    Library.BR2.From = Vector2.new(BR.X, BR.Y)
                    Library.BR2.To = Vector2.new(BR.X, BR.Y - offset)

                    Vis(Library, true)

                    if Settings.Autothickness then
                        local distance = (Player.Character.HumanoidRootPart.Position - oripart.Position).magnitude
                        local value = math.clamp(1/distance*100, 1, 4) -- 0.1 is min thickness, 6 is max
                        for u, x in pairs(Library) do
                            x.Thickness = value
                        end
                    else 
                        for u, x in pairs(Library) do
                            x.Thickness = Settings.Box_Thickness
                        end
                    end
                else 
                    Vis(Library, false)
                end
            else 
                Vis(Library, false)
                if game:GetService("Players"):FindFirstChild(plr.Name) == nil then
                    for i, v in pairs(Library) do
                        v:Remove()
                        oripart:Destroy()
                    end
                    c:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

-- Draw Boxes
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= Player.Name then
      coroutine.wrap(Main)(v)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(newplr)
    coroutine.wrap(Main)(newplr)
end)
end)
