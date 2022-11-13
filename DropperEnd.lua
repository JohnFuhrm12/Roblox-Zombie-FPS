local endPoint = script.Parent

local tycoon = game.Workspace.Tycoons.Rionegro
local cash = tycoon:FindFirstChild("Cash")
local ore = nil

local function destroyOre(otherPart)
	if otherPart then
		ore = otherPart
	end

	if ore.Name == "VolcanicOre" or ore.Name == "RefinedOre" then
		ore:Destroy()
		if ore.Name == "VolcanicOre" then
			cash.Value += 1
		end
		if ore.Name == "RefinedOre" then
			cash.Value += 10
		end
	end
end

endPoint.Touched:Connect(destroyOre)