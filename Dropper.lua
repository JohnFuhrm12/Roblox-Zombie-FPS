local spawner = script.Parent

local tycoon = game.Workspace.Tycoons.Rionegro
local startDropper = tycoon.Models.StartDropper

local function spawnOre()
	while spawner.Transparency == 1 do  
		if startDropper.Base.Transparency == 0 then
			wait(5)
			local droparea = spawner
			local ore = game.ReplicatedStorage.Ore.VolcanicOre:Clone()
			ore.Orientation = droparea.Orientation
			ore.Position = droparea.Position  
			ore.Parent = tycoon
		else
			wait()
		end
	end
end

spawnOre()