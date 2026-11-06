-- Server-authoritative slap tool with no cooldown.
-- Place this Script in ServerScriptService.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local connectedTools = {}

local function getCharacterOwner(tool)
    local character = tool.Parent
    if not character or not character:IsA("Model") then
        return nil, nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local player = Players:GetPlayerFromCharacter(character)
    if not humanoid or humanoid.Health <= 0 or not player then
        return nil, nil
    end

    return player, character
end

local function findTarget(player, character, range)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return nil, nil
    end

    local direction = root.CFrame.LookVector * range
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { character }
    raycastParams.IgnoreWater = true

    local result = Workspace:Raycast(root.Position, direction, raycastParams)
    if not result then
        return nil, nil
    end

    local targetCharacter = result.Instance:FindFirstAncestorOfClass("Model")
    if not targetCharacter or targetCharacter == character then
        return nil, nil
    end

    local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetHumanoid or not targetRoot or targetHumanoid.Health <= 0 then
        return nil, nil
    end

    local targetPlayer = Players:GetPlayerFromCharacter(targetCharacter)
    if targetPlayer == player then
        return nil, nil
    end

    return targetHumanoid, targetRoot
end

local function activateSlap(tool)
    local player, character = getCharacterOwner(tool)
    if not player then
        return
    end

    local range = math.clamp(tool:GetAttribute("SlapRange") or 8, 1, 30)
    local force = math.clamp(tool:GetAttribute("SlapForce") or 75, 0, 250)
    local upwardForce = math.clamp(tool:GetAttribute("SlapUpwardForce") or 25, 0, 150)
    local damage = math.max(tool:GetAttribute("SlapDamage") or 0, 0)

    local targetHumanoid, targetRoot = findTarget(player, character, range)
    if not targetHumanoid then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    local direction = (targetRoot.Position - root.Position).Unit
    targetRoot.AssemblyLinearVelocity = direction * force + Vector3.new(0, upwardForce, 0)
    if damage > 0 then
        targetHumanoid:TakeDamage(damage)
    end
end

local function connectTool(instance)
    if not instance:IsA("Tool") or instance.Name ~= "Slap" or connectedTools[instance] then
        return
    end

    connectedTools[instance] = instance.Activated:Connect(function()
        -- There is intentionally no debounce or cooldown here.
        activateSlap(instance)
    end)

    instance.Destroying:Connect(function()
        connectedTools[instance] = nil
    end)
end

for _, instance in ipairs(Workspace:GetDescendants()) do
    connectTool(instance)
end

Workspace.DescendantAdded:Connect(connectTool)

Players.PlayerAdded:Connect(function(player)
    player.Backpack.DescendantAdded:Connect(connectTool)
    player.CharacterAdded:Connect(function(character)
        character.DescendantAdded:Connect(connectTool)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.Backpack.DescendantAdded:Connect(connectTool)
    if player.Character then
        player.Character.DescendantAdded:Connect(connectTool)
    end
end
