local button = script.Parent
local Players = game:GetService("Players")

local tycoon = game.Workspace.Tycoons.Rionegro
local ownerValue = tycoon:FindFirstChild("Owner")
local cash = tycoon:FindFirstChild("Cash")

local barbedBackWrap = tycoon.Models.BarbedWireBackWrapper
local moduleFolder = game.ReplicatedStorage.TycoonModules
local priceModule = require(moduleFolder.Prices)

local price = priceModule.barbedWireLargePrice

local purchased = button.Purchased.Value

local user = nil

local function purchase()
	if purchased == 1 then
		cash.Value = cash.Value - 5
	end
end

local function disappear(otherPart)
	local partParent = otherPart.Parent
	local humanoid = partParent:FindFirstChild("Humanoid")
	local player = game:GetService("Players"):GetPlayerFromCharacter(humanoid.Parent)
	
	if player then
		user = tostring(player.UserId)
	end
	
	if player and user and ownerValue.Value == user and cash.Value >= price then
		wait(0.5)
		button.Transparency = 1
		button.CanCollide = false
		button.BillboardGui.TextLabel.TextTransparency = 1
		for _,mod in pairs (barbedBackWrap:GetChildren()) do 
			if mod then
				for _,obj in pairs (mod:GetChildren()) do
					if obj.ClassName == "Part" then 
						obj.Transparency = 0
						obj.CanTouch = true
					end
				end
			end
		end
		purchased += 1
		purchase()
	end
end

button.Touched:Connect(disappear)
