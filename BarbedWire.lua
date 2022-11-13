local wireWrapper = script.Parent
local Players = game:GetService("Players")

local function cut(otherPart)
	local partParent = otherPart.Parent
	local humanoid = partParent:FindFirstChild("Humanoid")
	
	if humanoid then
		humanoid.Health -= 0.1
		if humanoid.WalkSpeed > 5 then
			humanoid.WalkSpeed -= 0.1
		end
	end
end

for _,model in pairs (wireWrapper:GetChildren()) do
	if model.ClassName == "Model" then
		for i, wire in pairs(model:GetChildren()) do
			if wire.ClassName == "Part" then
				wire.Touched:Connect(cut)
			end
		end
	end
end
