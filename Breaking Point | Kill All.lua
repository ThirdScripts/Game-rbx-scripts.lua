game:GetService("Players").LocalPlayer.Idled:connect(function()
game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

if game.PlaceId == 648362523 then
    repeat wait() until game:IsLoaded()
    game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "Breaking Point AutoFarm Credits",
            Text = "Updated by qa#0001, aka 2vsh on Roblox."
        }
    )
    
    
    
    Clone = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Clone()
    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Destroy()
    Clone.Parent = game:GetService("Players").LocalPlayer.Character
    game.Players.LocalPlayer.settings["Display Gun"].Value = true
    game.Players.LocalPlayer.CharacterAdded:Connect(
        function()
            if getgenv().AutoFarm then
                pcall(function()
                game.Players.LocalPlayer.settings["Display Gun"].Value = true
                wait(4)
                Clone = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Clone()
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Destroy()
                Clone.Parent = game:GetService("Players").LocalPlayer.Character
                end)
            end
        end
    )

    while getgenv().AutoFarm do
        pcall(function()
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer(16, "public")
        end)
        wait()
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.Name == game.Players.LocalPlayer.Name then
            else
                pcall(function()
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer(30, v)
                end)
            end
        end
    end
else
    game:GetService("TeleportService"):Teleport(648362523, LocalPlayer)
end


if getgenv().ServerHop == true then
wait (1500)
game:GetService("TeleportService"):Teleport(648362523, LocalPlayer)
end
