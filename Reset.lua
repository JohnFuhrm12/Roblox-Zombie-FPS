local team = game:GetService("Teams")["Rionegro Outpost"]
local riverOutpostTycoon = game.Workspace.Tycoons.Rionegro

local buttonsFolder = riverOutpostTycoon.Buttons
local modelsFolder = riverOutpostTycoon.Models

team.PlayerRemoved:Connect(function()
	riverOutpostTycoon.Cash.Value = 0
	riverOutpostTycoon.Owner.Value = nil
	
	riverOutpostTycoon.ClaimDoor.Part.Transparency = 0
	riverOutpostTycoon.ClaimDoor.Part.CanCollide = true
	riverOutpostTycoon.ClaimDoor.Part.BillboardGui.TextLabel.TextTransparency = 1
	
	riverOutpostTycoon.OwnerDoor.OwnerDoor.Transparency = 1
	riverOutpostTycoon.OwnerDoor.OwnerDoor.CanCollide = false
	riverOutpostTycoon.OwnerDoor.OwnerDoor.CanTouch = false
	
	for i, button in pairs(buttonsFolder:GetChildren()) do 
		button.Transparency = 0
		button.CanCollide = true
		button.BillboardGui.TextLabel.TextTransparency = 0
		if button.Name ~= "StartButton" then
			button.Purchased.Value = 0
		end
	end
	
	for i, model in pairs(modelsFolder:GetChildren()) do 
		for i, modelChildren in pairs(model:GetChildren()) do
			if modelChildren.ClassName == "Part" or modelChildren.ClassName == "UnionOperation" or modelChildren.ClassName == "MeshPart" or modelChildren.ClassName == "TrussPart" or modelChildren.ClassName == "WedgePart" or modelChildren.ClassName == "CornerWedgePart" then
				modelChildren.Transparency = 1
				modelChildren.CanCollide = false
				modelChildren.CanTouch = false
			end
			if modelChildren.ClassName == "Model" then
				for i, secondChild in pairs(modelChildren:GetChildren()) do
					if secondChild.ClassName == "Part" or secondChild.ClassName == "UnionOperation" or secondChild.ClassName == "MeshPart" or secondChild.ClassName == "TrussPart" or secondChild.ClassName == "WedgePart" or secondChild.ClassName == "CornerWedgePart"  then
						secondChild.Transparency = 1
						secondChild.CanCollide = false
						secondChild.CanTouch = false
					end
				end
			end
		end
	end
end)