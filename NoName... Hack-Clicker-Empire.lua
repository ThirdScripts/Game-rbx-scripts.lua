local replicatedStorage = game:GetService("ReplicatedStorage")

local basicClick = replicatedStorage:WaitForChild("basicClick")
local tap = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Tap")
local hatchServer = replicatedStorage:WaitForChild("EggHatchingRemotes"):WaitForChild("HatchServer")
local hatchArgs = {
    [1] = {
        [1] = { ["Name"] = "Walking Monser", ["Rarity"] = 40 },
        [2] = { ["Name"] = "Spooky Raven", ["Rarity"] = 30 },
        [3] = { ["Name"] = "Spooky Fox", ["Rarity"] = 15 },
        [4] = { ["Name"] = "Witch Cat", ["Rarity"] = 10 },
        [5] = { ["Name"] = "Pipkin", ["Rarity"] = 5 },
        [6] = { ["Name"] = "Sproutkin", ["Rarity"] = 0.1 },
        [7] = { ["Name"] = "Jaxkin", ["Rarity"] = 0.01 },
        [8] = { ["Name"] = "Pumpking", ["Rarity"] = 0.001 }
    },
    [2] = 1,
    [3] = 500,
    [4] = {},
    [5] = "Candy",
    [6] = 1
}

spawn(function()
    while true do
        basicClick:FireServer()
        wait(0.01)
    end
end)

spawn(function()
    while true do
        tap:FireServer()
        wait(0.01)
    end
end)

spawn(function()
    while true do
        hatchServer:InvokeServer(unpack(hatchArgs))
        wait(1)
    end
end)
