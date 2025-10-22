local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("WestbounHackV1.0", "Ocean")

local Tab = Window:NewTab("Main")

local Section = Tab:NewSection("Aimbot")

-- Аимбот по нажатию рычаг
Section:NewToggle("Aimbot", "ToggleInfo", function(state)
    if state then
        -- Enable Script
_G.AimBotEnabled = true

local camera = workspace.CurrentCamera
local players = game:GetService("Players")
local user = players.LocalPlayer
local inputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local predictionFactor, aimSpeed = 0.042, 10
local holding = false

if not user then return warn("LocalPlayer не найден!") end

-- Создаем FOV круг
if not _G.FOVCircle then
    _G.FOVCircle = Drawing.new("Circle")
    _G.FOVCircle.Radius, _G.FOVCircle.Filled, _G.FOVCircle.Thickness = 200, false, 1 -- Начальный радиус: 200
    _G.FOVCircle.Color, _G.FOVCircle.Transparency, _G.FOVCircle.Visible = Color3.new(1, 1, 1), 0.7, true
end

-- Получение ближайшего игрока
local function getClosestPlayer()
    local closest, minDist = nil, math.huge
    local currentRadius = _G.FOVCircle and _G.FOVCircle.Radius or 200 -- Используем текущий радиус FOV
    for _, player in pairs(players:GetPlayers()) do
        if player ~= user and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local head = player.Character:FindFirstChild("Head")
            local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - inputService:GetMouseLocation()).Magnitude
            if onScreen and distance <= currentRadius and distance < minDist then
                closest, minDist = player, distance
            end
        end
    end
    return closest
end

-- Предсказание позиции
local function predictHead(target)
    local head = target.Character.Head
    local velocity = target.Character.HumanoidRootPart.AssemblyLinearVelocity or Vector3.zero
    return head.Position + velocity * predictionFactor
end

-- Обработчики ввода
inputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then holding = true end
end)

inputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then holding = false end
end)

-- Основной цикл
runService.RenderStepped:Connect(function()
    if not _G.AimBotEnabled then return end
    if _G.FOVCircle then
        _G.FOVCircle.Position = inputService:GetMouseLocation()
    end
    if holding then
        local target = getClosestPlayer()
        if target then
            local predicted = predictHead(target)
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, predicted), aimSpeed * 0.1)
        end
    end
end)
    else
        -- Disable Script
_G.AimBotEnabled = false -- Отключаем функционал аимбота

-- Удаляем FOV круг, если он существует
if _G.FOVCircle then
    _G.FOVCircle:Remove() -- Удаляем объект
    _G.FOVCircle = nil    -- Очищаем переменную
end

-- Очищаем глобальные переменные, если требуется
_G.PredictionFactor = nil
_G.AimSpeed = nil
    end
end)


-- Настройка FOV через текстбокс
Section:NewTextBox("Set FOV Radius", "Enter a number for FOV size", function(txt)
    local newRadius = tonumber(txt) -- Преобразуем введенный текст в число
    if newRadius and _G.FOVCircle then
        _G.FOVCircle.Radius = math.clamp(newRadius, 10, 500) -- Ограничиваем значение от 10 до 500
        print("FOV Radius set to:", _G.FOVCircle.Radius)
    else
        warn("Invalid input! Please enter a number.")
    end
end)

local Section = Tab:NewSection("Speedhacks")

--спидхак по нажатию X
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local bodyVelocity = nil
local userInputService = game:GetService("UserInputService")

local speed = 100  -- Начальная скорость (можно будет изменять через TextBox)

-- Функция для обновления персонажа при возрождении
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end

-- Функция для включения спидхака
local function speedHack()
    if not bodyVelocity then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * speed
        bodyVelocity.Parent = humanoidRootPart
    else
        bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * speed
    end
end

-- Функция для выключения спидхака
local function disableSpeedHack()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

-- Отслеживание нажатия клавиши X
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.X then
        speedHack()
    end
end)

-- Отслеживание отпускания клавиши X
userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.X then
        disableSpeedHack()
    end
end)

-- Подписка на событие возрождения
player.CharacterAdded:Connect(onCharacterAdded)

-- TextBox для изменения скорости
Section:NewTextBox("Speedhack(PressX)", "TextboxInfo", function(txt)
    local newSpeed = tonumber(txt)  -- Преобразуем текст в число
    if newSpeed then
        speed = newSpeed  -- Обновляем скорость
        print("Скорость изменена на:", speed)
    else
        print("Введите числовое значение скорости!")
    end
end)

local speed = 0 -- Начальная скорость (по умолчанию 0)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Функция для настройки перемещения
local function setupMovement()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Подключаемся к RenderStepped
    game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
        if not humanoidRootPart or not humanoidRootPart.Parent then return end

        local moveDirection = Vector3.new(0, 0, 0)
        local userInputService = game:GetService("UserInputService")

        -- Проверяем нажатие клавиш WASD
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Vector3.new(0, 0, -1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection + Vector3.new(0, 0, 1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection + Vector3.new(-1, 0, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Vector3.new(1, 0, 0)
        end

        -- Нормализуем и перемещаем персонажа
        if moveDirection.Magnitude > 0 and speed > 0 then
            moveDirection = moveDirection.Unit
            local worldDirection = humanoidRootPart.CFrame:VectorToWorldSpace(moveDirection)
            local newPosition = humanoidRootPart.Position + worldDirection * speed * deltaTime

            -- Перемещаем персонажа без изменения его ориентации
            humanoidRootPart.CFrame = CFrame.new(newPosition, newPosition + humanoidRootPart.CFrame.LookVector)
        end
    end)
end

-- Добавляем текстбокс для изменения скорости
Section:NewTextBox("SpeedhackCFrame", "Defolt 0", function(txt)
    local newSpeed = tonumber(txt)
    if newSpeed then
        speed = newSpeed
        print("Скорость изменена на:", speed)
    else
        print("Введите корректное число!")
    end
end)

-- Обновляем переменные после смерти
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    setupMovement()
end)

-- Настраиваем движение для текущего персонажа
setupMovement()

local Section = Tab:NewSection("OtherHacks")


Section:NewToggle("NoLasso", "ToggleInfo", function(state)
    if state then
        _G.ToggleScript = true  -- Глобальная переменная для включения/выключения

while true do
    if _G.ToggleScript then
        local args = {
            [1] = "BreakFree"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("GeneralEvents"):WaitForChild("LassoEvents"):FireServer(unpack(args))
    end
    task.wait(0.01)  -- Минимальная задержка для корректной работы цикла 
end
    else
        _G.ToggleScript = false
    end
end)

-- Переключатель ноуклип
Section:NewToggle("NoClip", "ToggleInfo", function(state)
    if state then
        local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function noclip()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end


local function clip()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

noclip()


    else
        local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function enableCollisions()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

enableCollisions()

    end
end)



--Секция визуал
local Tab = Window:NewTab("Visual")
local Section = Tab:NewSection("Wallhack")

Section:NewToggle("Chams", "ToggleInfo", function(state)
    if state then
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/ChamsTeamColor/refs/heads/main/ChamsColorTeam.lua"))()
    else
        _G.ESP_Enabled = false

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    if player.Character then
        for _, v in ipairs(player.Character:GetChildren()) do
            if v:IsA("Highlight") then
                v:Destroy()
            end
        end
    end
end
    end
end)
getgenv().Toggled = false

-- ESP
Section:NewButton("ESP", "ButtonInfo", function()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/ESPteamcolor/refs/heads/main/ESP.lua"))()
end)

local Section = Tab:NewSection("Other")

-- Переключатель Blur
Section:NewToggle("Blur", "ToggleInfo", function(state)
    if state then
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/Blur/refs/heads/main/blur.lua"))()
    else
        game:GetService("Lighting"):ClearAllChildren()
    end
end)

-- Переключатель фулбридж
Section:NewToggle("Fullbright", "ToggleInfo", function(state)
    if state then
        _G.LightingEnabled = true

local Lighting = game:GetService("Lighting")

if _G.LightingEnabled then
  
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.FogEnd = 1e10

   
    Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
        if _G.LightingEnabled then
            Lighting.Ambient = Color3.new(1, 1, 1)
        end
    end)

    Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
        if _G.LightingEnabled then
            Lighting.Brightness = 2
        end
    end)

    Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function()
        if _G.LightingEnabled then
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end
    end)

    Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
        if _G.LightingEnabled then
            Lighting.FogEnd = 1e10
        end
    end)
end

    else
        _G.LightingEnabled = false

local Lighting = game:GetService("Lighting")

-- Устанавливаем чуть более светлый нейтральный свет
Lighting.Ambient = Color3.new(0.7, 0.7, 0.7) -- Легкий серый оттенок
Lighting.Brightness = 1 -- Стандартная яркость
Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.7) -- Тот же светлый серый
Lighting.FogEnd = 100000 -- Ограничение на дальность тумана

    end
end)
getgenv().Toggled = false




-- чинахат

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local coneColor = Color3.fromRGB(173, 216, 230) -- Нежно-голубой цвет
local coneCreated = false -- Конус ещё не создан

-- Функция для создания конуса
local function createCone(character)
    if not coneColor then return end -- Создаём конус только если цвет выбран

    local head = character:FindFirstChild("Head")
    if not head then return end

    local cone = Instance.new("Part")
    cone.Size = Vector3.new(1, 1, 1)
    cone.BrickColor = BrickColor.new("White")
    cone.Transparency = 0.3
    cone.Anchored = false
    cone.CanCollide = false

    local mesh = Instance.new("SpecialMesh", cone)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1033714"
    mesh.Scale = Vector3.new(1.7, 1.1, 1.7)

    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = cone
    weld.C0 = CFrame.new(0, 0.9, 0)

    cone.Parent = character
    weld.Parent = cone

    -- Добавляем Highlight
    local highlight = Instance.new("Highlight", cone)
    highlight.FillColor = coneColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = coneColor
    highlight.OutlineTransparency = 0

    coneCreated = true -- Помечаем, что конус создан
end

-- Пересоздаём конус после респавна
local function onCharacterAdded(character)
    if coneCreated then -- Если конус уже был создан, пересоздаём
        createCone(character)
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

-- Если персонаж уже существует
if player.Character then
    onCharacterAdded(player.Character)
end

-- ColorPicker
Section:NewColorPicker("Chinahat", "Color Info", Color3.fromRGB(173, 216, 230), function(color)
    coneColor = color -- Обновляем цвет для конуса
    if player.Character and not coneCreated then
        createCone(player.Character) -- Создаём конус только после выбора цвета
    elseif player.Character and coneCreated then
        -- Обновляем цвет существующего конуса
        for _, v in ipairs(player.Character:GetChildren()) do
            if v:IsA("Part") and v:FindFirstChild("Highlight") then
                local highlight = v:FindFirstChild("Highlight")
                highlight.FillColor = coneColor
                highlight.OutlineColor = coneColor
            end
        end
    end
end)





--Секция автофарм
local Tab = Window:NewTab("AutoFarm(Demo)")
local Section = Tab:NewSection("AutofarmGrayRidge")


-- Кнопка Chams
Section:NewButton("AutoFly", "ButtonInfo", function()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/AutoFlyWestbound/refs/heads/main/AutoFly.lua"))()
end)
-- Кнопка Chams
Section:NewButton("AutoRob", "ButtonInfo", function()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/AutoFlyWestbound/refs/heads/main/AutoRobOpen.lua"))()
end)


-- секция килл алл
local Tab = Window:NewTab("Mics")
local Section = Tab:NewSection("KillAll")

-- Рычаг TpAllOutlaws
Section:NewToggle("KillAllOutlaws", "ToggleInfo", function(state)
    if state then
        _G.RunScript = true  -- Глобальная переменная для управления скриптом

-- Фиксируем позицию запуска скрипта
local localPlayer = game.Players.LocalPlayer
local startPosition = nil

if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
    startPosition = localPlayer.Character.HumanoidRootPart.CFrame
else
    warn("Скрипт не может определить позицию LocalPlayer.")
    return
end

while true do
    if _G.RunScript then
        -- Проверяем, что начальная позиция зафиксирована
        if startPosition then
            local spacing = 3 -- Расстояние между игроками в линии
            local positionOffset = 0 -- Начальный сдвиг для первого игрока

            for _, player in ipairs(game.Players:GetPlayers()) do
                -- Исключаем LocalPlayer и проверяем, что игрок из команды "Outlaws"
                if player ~= localPlayer and player.Team and player.Team.Name == "Outlaws" then
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart

                        -- Сбрасываем инерцию
                        hrp.Velocity = Vector3.zero
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero

                        -- Рассчитываем позицию в линии перед сохранённой позицией LocalPlayer
                        local newPosition = startPosition.Position + (startPosition.LookVector * 5) + Vector3.new(positionOffset, 0, 0)

                        -- Телепортируем игрока
                        hrp.CFrame = CFrame.new(newPosition)

                        -- Увеличиваем сдвиг для следующего игрока
                        positionOffset = positionOffset + spacing
                    end
                end
            end
        end
    end

    wait(0.1)  -- Минимальная задержка для предотвращения зависания
end
    else
        _G.RunScript = false
    end
end)

-- Рычаг TpAllCawboys
Section:NewToggle("TpAllCawboys", "ToggleInfo", function(state)
    if state then
        _G.RunScript = true  -- Глобальная переменная для управления скриптом

-- Фиксируем позицию запуска скрипта
local localPlayer = game.Players.LocalPlayer
local startPosition = nil

if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
    startPosition = localPlayer.Character.HumanoidRootPart.CFrame
else
    warn("Скрипт не может определить позицию LocalPlayer.")
    return
end

while true do
    if _G.RunScript then
        -- Проверяем, что начальная позиция зафиксирована
        if startPosition then
            local spacing = 3 -- Расстояние между игроками в линии
            local positionOffset = 0 -- Начальный сдвиг для первого игрока

            for _, player in ipairs(game.Players:GetPlayers()) do
                -- Исключаем LocalPlayer и проверяем, что игрок из команды "Cowboys"
                if player ~= localPlayer and player.Team and player.Team.Name == "Cowboys" then
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart

                        -- Сбрасываем инерцию
                        hrp.Velocity = Vector3.zero
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero

                        -- Рассчитываем позицию в линии перед сохранённой позицией LocalPlayer
                        local newPosition = startPosition.Position + (startPosition.LookVector * 5) + Vector3.new(positionOffset, 0, 0)

                        -- Телепортируем игрока
                        hrp.CFrame = CFrame.new(newPosition)

                        -- Увеличиваем сдвиг для следующего игрока
                        positionOffset = positionOffset + spacing
                    end
                end
            end
        end
    end

    wait(0.1)  -- Минимальная задержка для предотвращения зависания
end
    else
        _G.RunScript = false
    end
end)
