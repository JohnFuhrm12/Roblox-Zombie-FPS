local walker = script.Parent
local humanoid = script.Parent:WaitForChild("Humanoid")

local walkerCount = game.Workspace.CurrentZombieCount:FindFirstChild("WalkerCount")

local player, distance;

humanoid.WalkSpeed = 5

local walkAnim = script:WaitForChild("WalkAnim")
local walkTrack = humanoid:LoadAnimation(walkAnim)

local attackAnim = script:WaitForChild("AttackAnim")
local attackTrack = humanoid:LoadAnimation(attackAnim)

local isWalking = false
local isWalkingAnim = true
local walkVal = 3

local isAttacking = false
local isAttackingVal = 3
local attackDistance = 5.5

local torso = nil

walkTrack:Play()
walkTrack.Looped = true

local isRaycasting = true

local moan1Sound = Instance.new("Sound")
moan1Sound.SoundId = "rbxassetid://11505315489"
moan1Sound.Looped = false
moan1Sound.Parent = walker.Head

local attackSound = Instance.new("Sound")
attackSound.SoundId = "rbxassetid://11505526049"
attackSound.Looped = false
attackSound.Parent = walker.Head

local function rayCast() 
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {walker, player}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	local raycastDirection = Vector3.new(0,0,5)
	
	torso = walker:WaitForChild("LowerTorsoW")
	
	if torso ~= nil then
		local raycastResult = workspace:Raycast(walker.LowerTorsoW.Position, raycastDirection, raycastParams)
		local raycastResultHigh = workspace:Raycast(walker.Head.Position, raycastDirection, raycastParams)

		if raycastResult and not raycastResultHigh then
			local hitPart = raycastResult.Instance

			walker.Humanoid.Jump = true	
		end
	end
end

function getClosestPlayer()
	local closestPlayer, closestDistance = nil, 200
	for i, player in pairs(workspace:GetChildren()) do
		if player:FindFirstChild("Humanoid") and player ~= walker and player.Name ~= "Walker" and player.Name ~= "Runner" and player.Name ~= "Tank" and player.Name ~= "Pouncer" then
			local distance = (walker.PrimaryPart.Position - player.PrimaryPart.Position).Magnitude
			if distance < closestDistance then
				closestPlayer = player
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end

for _,obj in pairs (walker:GetChildren()) do 
	if obj.ClassName == "Part" and humanoid.Health > 0 then 
		obj.Touched:Connect(function(otherPart)
			local partParent = otherPart.Parent
			local hum = partParent:FindFirstChild("Humanoid")
			local player = game:GetService("Players"):GetPlayerFromCharacter(partParent.Parent)

			if hum and partParent.Name ~= "Walker" and partParent.Name ~= "Runner" and partParent.Name ~= "Tank" and partParent.Name ~= "Pouncer" then
				hum.Health -= 30
			end
		end)
	end
end

local moanCour = coroutine.create(function()
	while true do
		if isWalking then
			wait(60)
			moan1Sound:Play()
			moan1Sound.Ended:wait()
			moan1Sound:Destroy()
		end
		wait()
	end
end)

coroutine.resume(moanCour)


while true do
	player, distance = getClosestPlayer()
	
	if humanoid.MoveDirection.Magnitude > 0 then
		isWalking = true
	end
	if humanoid.MoveDirection.Magnitude == 0 then
		isWalking = true
	end
	
	if isWalking and not isWalkingAnim then
		walkTrack:Play()
	end
	
	if not isWalking then
		walkTrack:Stop()
	end
	
	if player and distance > attackDistance then
		walker.Humanoid:MoveTo(player.PrimaryPart.Position)
		humanoid.WalkSpeed = 5
		isAttacking = false
		isAttackingVal = 3
		wait(0.1)
		walkVal += 1
		if walkVal == 5 then 
			attackTrack:Stop()
			walkTrack:Play()
		end
	end
	
	if player and distance <= attackDistance then
		walker.Humanoid:MoveTo(player.PrimaryPart.Position)
		isAttacking = true
		wait(0.1)
		isAttackingVal += 1
		if isAttackingVal == 5 then
			walkVal = 3
			humanoid.WalkSpeed = 3
			walkTrack:Stop()
			attackTrack:Play()
			attackSound:Play()
			attackSound.Ended:wait()
			attackSound:Destroy()
		end
	end
	
	if humanoid.Health == 0 then
		walkerCount.Value -= 1
		walkTrack:Stop()
		wait(2)
		walker:Destroy()
	end
	
	if isRaycasting then
		wait(0.5)
		rayCast()
	end

	wait()
end
