local spawner = script.Parent
local spawnPos = spawner.Position

local islandStatus = game.Workspace.IslandStatus
local tycoon = game.Workspace.Tycoons["Center Stronghold"]

local owner = tycoon.Owner
local ownerValue = nil

owner.Changed:Connect(function()
	ownerValue = owner.Value
end)

_G.spawningWalkers = true
_G.spawningRunners = false
_G.spawningTanks = false
_G.spawningPouncers = false

_G.spawningHorde = false

local walkerCount = game.Workspace.CurrentZombieCount:FindFirstChild("WalkerCount")
local runnerCount = game.Workspace.CurrentZombieCount:FindFirstChild("RunnerCount")
local tankCount = game.Workspace.CurrentZombieCount:FindFirstChild("TankCount")
local pouncerCount = game.Workspace.CurrentZombieCount:FindFirstChild("PouncerCount")

local hordeCount = game.Workspace.CurrentZombieCount:FindFirstChild("HordeCount")

local spawnTime = 10

while true do 
	if ownerValue ~= nil then
		if _G.spawningWalkers and walkerCount.Value < 30 then
			wait(spawnTime)
			islandStatus.Value = "Walkers.."
			walkerCount.Value += 1
			local walker = game.ReplicatedStorage.Zombies.Walker:Clone()
			walker.Parent = workspace
			walker:MoveTo(spawnPos)
		end
		if _G.spawningRunners and runnerCount.Value < 30 then
			wait(spawnTime)
			islandStatus.Value  = "Runners!"
			runnerCount.Value += 1
			local runner = game.ReplicatedStorage.Zombies.Runner:Clone()
			runner.Parent = workspace
			runner:MoveTo(spawnPos)
		end
		if _G.spawningTanks and tankCount.Value < 30 then
			wait(spawnTime)
			islandStatus.Value  = "Tanks!!!"
			tankCount.Value += 1
			local tank = game.ReplicatedStorage.Zombies.Tank:Clone()
			tank.Parent = workspace
			tank:MoveTo(spawnPos)
		end
		if _G.spawningPouncers and pouncerCount.Value < 30 then
			wait(spawnTime)
			islandStatus.Value  = "Pouncers.."
			pouncerCount.Value += 1
			local pouncer = game.ReplicatedStorage.Zombies.Pouncer:Clone()
			pouncer.Parent = workspace
			pouncer:MoveTo(spawnPos)
		end




		if _G.spawningHorde and hordeCount.Value < 50 then
			wait(0.5)
			islandStatus.Value  = "HORDE"

			local walker = game.ReplicatedStorage.Zombies.Walker:Clone()
			walker.Parent = workspace
			walker:MoveTo(spawnPos)
			hordeCount.Value += 1 
			wait(spawnTime)

			local runner = game.ReplicatedStorage.Zombies.Runner:Clone()
			runner.Parent = workspace
			runner:MoveTo(spawnPos)
			hordeCount.Value += 1 
			wait(spawnTime)

			local tank = game.ReplicatedStorage.Zombies.Tank:Clone()
			tank.Parent = workspace
			tank:MoveTo(spawnPos)
			hordeCount.Value += 1 
			wait(spawnTime)

			local pouncer = game.ReplicatedStorage.Zombies.Pouncer:Clone()
			pouncer.Parent = workspace
			pouncer:MoveTo(spawnPos)
			hordeCount.Value += 1  
			wait(spawnTime)
		end
	end
	wait()
end



