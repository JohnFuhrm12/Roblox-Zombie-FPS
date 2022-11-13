local spawnWalkers = true
local spawnRunners = false
local spawnTanks = false
local spawnPouncers = false

local spawnHorde = false

local roundTime = 180

while true do
	if spawnWalkers then
		print("Walkers")
		_G.spawningWalkers = true
		wait(roundTime)
		print("Runners")
		_G.spawningWalkers = false
		_G.spawningRunners = true
		spawnWalkers = false
		spawnRunners = true
	end
	
	if spawnRunners then
		_G.spawningRunners = true
		wait(roundTime)
		print("Tanks")
		_G.spawningRunners = false
		_G.spawningTanks = true
		spawnRunners = false
		spawnTanks = true
	end
	
	if spawnTanks then
		_G.spawningTanks = true
		wait(roundTime)
		_G.spawningTanks = false
		_G.spawningPouncers = true
		spawnTanks = false
		spawnPouncers = true
	end

	if spawnPouncers then
		_G.spawningPouncers = true
		wait(roundTime)
		_G.spawningPouncers = false
		_G.spawningHorde = true
		spawnPouncers = false
		spawnHorde = true
	end
	
	if spawnHorde then
		_G.spawningHorde = true
		wait(roundTime)
		_G.spawningHorde = false
		_G.spawningWalkers = true
		spawnHorde = false
		spawnWalkers = true
	end
	wait()
end