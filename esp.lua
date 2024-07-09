local function createHighlight(character, isLocalPlayer)
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillTransparency = 1 
    highlight.OutlineColor = isLocalPlayer and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0 
    highlight.Adornee = character
    highlight.Parent = character
end
local function createNameTag(character)
    local head = character:WaitForChild("Head")
    local player = game.Players:GetPlayerFromCharacter(character)
    if player then
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "NameTag"
        billboardGui.Size = UDim2.new(0, 50, 0, 25)
        billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
        billboardGui.Adornee = head
        billboardGui.AlwaysOnTop = true
 
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextScaled = true
        textLabel.Parent = billboardGui
 
        billboardGui.Parent = head
 
        local localPlayer = game.Players.LocalPlayer
        local updateConnection
        updateConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                billboardGui.Enabled = distance > 100
            else
                updateConnection:Disconnect()
            end
        end)
    end
end
 
local function onCharacterAdded(character, isLocalPlayer)
    character:WaitForChild("HumanoidRootPart")
    createHighlight(character, isLocalPlayer)
    createNameTag(character)
end
 
local function onPlayerAdded(player)
    local isLocalPlayer = player == game.Players.LocalPlayer
 
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character, isLocalPlayer)
    end)
 
    local character = player.Character
    if character then
        onCharacterAdded(character, isLocalPlayer)
    end
end
 
game.Players.PlayerAdded:Connect(onPlayerAdded)
 
for _, player in ipairs(game.Players:GetPlayers()) do
    onPlayerAdded(player)
end
