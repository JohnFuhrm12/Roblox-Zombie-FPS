local player = game.Players.LocalPlayer
local character = player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local mouse = game.Players.LocalPlayer:GetMouse()

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local PlayerService = game:GetService("Players")
local plr = game:GetService('Players').LocalPlayer
--local glockAmmo = plr.Backpack.Glock:WaitForChild("GlockAmmo")

local glockAmmoCount = 17
local wasEmpty = false

_G.glockAmmo.Changed:Connect(function()
	glockAmmoCount = _G.glockAmmo.Value
end)

--local m4Ammo = plr.Backpack.M4A1:WaitForChild("M4 Ammo")

local m4AmmoCount = 30

_G.m4Ammo.Changed:Connect(function()
	m4AmmoCount = _G.m4Ammo.Value
end)

local camera = game.Workspace.CurrentCamera
local mouse = game.Players.LocalPlayer:GetMouse()

local equipped = false
local check = false

local aimCF = CFrame.new()

local isAiming = false

local currentSwayAMT = -0.3;
local swayAMT = 0.2;
local aimSwayAMT = 0.2;
local swayCF = CFrame.new()
local lastCameraCF = CFrame.new()

local fireAnim = nil
local reloadAnim = nil
local fullAutoAnim = nil

local glockEmptyAnim = nil
local glockEmptyIdleAnim = nil

local muzzleFlash = nil

_G.framework = {
	inventory = {
		"Glock";
		"M4A1";
	};
	
	module = nil;
	viewmodel = nil;
	currentSlot = 1;
}

_G.loadSlot = function(Item)
	local viewmodelFolder = game.ReplicatedStorage.Viewmodels
	local moduleFolder = game.ReplicatedStorage.Modules
	
	for i,v in pairs(camera:GetChildren()) do
		if v:IsA("Model") then
			v:Destroy()
		end
	end
	
	if moduleFolder:FindFirstChild(Item) then
		_G.framework.module = require(moduleFolder:FindFirstChild(Item))
		
		if viewmodelFolder:FindFirstChild(Item) then
			_G.framework.viewmodel = viewmodelFolder:FindFirstChild(Item):Clone()
			_G.framework.viewmodel.Parent = camera
			
			if _G.framework.viewmodel.MuzzleFlash then
				muzzleFlash = _G.framework.viewmodel.MuzzleFlash
			end
			
			fireAnim = Instance.new("Animation")
			fireAnim.Parent = _G.framework.viewmodel
			fireAnim.Name = "Fire"
			fireAnim.AnimationId = _G.framework.module.fireAnim
			fireAnim = _G.framework.viewmodel.AnimationController.Animator:LoadAnimation(fireAnim)
			fireAnim.Priority = Enum.AnimationPriority.Action
			
			_G.fireAnim = fireAnim
			
			reloadAnim = Instance.new("Animation")
			reloadAnim.Parent = _G.framework.viewmodel
			reloadAnim.Name = "Fire"
			reloadAnim.AnimationId = _G.framework.module.reloadAnim
			reloadAnim = _G.framework.viewmodel.AnimationController.Animator:LoadAnimation(reloadAnim)
			reloadAnim.Priority = Enum.AnimationPriority.Action
			
			_G.reloadAnim = fireAnim
			
			if _G.framework.module.fullAutoAnim then
				fullAutoAnim = Instance.new("Animation")
				fullAutoAnim.Parent = _G.framework.viewmodel
				fullAutoAnim.Name = "FullAuto"
				fullAutoAnim.AnimationId = _G.framework.module.fullAutoAnim
				fullAutoAnim = _G.framework.viewmodel.AnimationController.Animator:LoadAnimation(fullAutoAnim)
				fullAutoAnim.Priority = Enum.AnimationPriority.Action
			end
			
			if _G.framework.module.glockEmptyAnim then
				glockEmptyAnim = Instance.new("Animation")
				glockEmptyAnim.Parent = _G.framework.viewmodel
				glockEmptyAnim.Name = "FullAuto"
				glockEmptyAnim.AnimationId = _G.framework.module.glockEmptyAnim
				glockEmptyAnim = _G.framework.viewmodel.AnimationController.Animator:LoadAnimation(glockEmptyAnim)
				glockEmptyAnim.Priority = Enum.AnimationPriority.Action
			end
			if _G.framework.module.glockEmptyIdleAnim then
				glockEmptyIdleAnim = Instance.new("Animation")
				glockEmptyIdleAnim.Parent = _G.framework.viewmodel
				glockEmptyIdleAnim.Name = "FullAuto"
				glockEmptyIdleAnim.AnimationId = _G.framework.module.glockEmptyIdleAnim
				glockEmptyIdleAnim = _G.framework.viewmodel.AnimationController.Animator:LoadAnimation(glockEmptyIdleAnim)
				glockEmptyIdleAnim.Priority = Enum.AnimationPriority.Action
			end
		end
	end
	
	if equipped == true then
		check = true
		for i,v in pairs(camera:GetChildren()) do
			if v:IsA("Model") then
				v:Destroy()
			end
		end
	end
end

RunService.RenderStepped:Connect(function()
	
	local rot = camera.CFrame:ToObjectSpace(lastCameraCF)
	local X,Y,Z = rot:ToOrientation()
	swayCF = swayCF:Lerp(CFrame.Angles(math.sin(X) * currentSwayAMT, math.sin(Y) * currentSwayAMT, 0), 0,1)
	lastCameraCF = camera.CFrame
	
	local humanoid = character:WaitForChild("Humanoid")
	
	if humanoid then
		local bobOffset = CFrame.new(math.cos(tick() * 5) * 0.1, -humanoid.CameraOffset.Y/3, -humanoid.CameraOffset.Z/3)
		
		if isAiming then
			bobOffset = CFrame.new(-humanoid.CameraOffset.X/10, -humanoid.CameraOffset.Y/10, -humanoid.CameraOffset.Z/10)
			humanoid.WalkSpeed = 12
		end
		if isAiming and _G.framework.currentSlot == 2 then
			bobOffset = CFrame.new(-humanoid.CameraOffset.X/10, -humanoid.CameraOffset.Y/30, -humanoid.CameraOffset.Z/10)
			humanoid.WalkSpeed = 12
		end
		if isAiming == false then
			bobOffset = CFrame.new(math.cos(tick() * 5) * 0.1, -humanoid.CameraOffset.Y/3, -humanoid.CameraOffset.Z/3)
		end
		if humanoid.MoveDirection.Magnitude == 0 and isAiming == false then
			bobOffset = CFrame.new(math.cos(tick() * 1.2) * 0.1, -humanoid.CameraOffset.Y/3, -humanoid.CameraOffset.Z/3)
		end

		for i, v in pairs(camera:GetChildren()) do
			if v:IsA("Model") then
				v:SetPrimaryPartCFrame(camera.CFrame * swayCF * aimCF * bobOffset)
			end
		end
	end
	
	if isAiming and _G.framework.viewmodel ~= nil and _G.framework.viewmodel.AimPart then
		local offset = _G.framework.viewmodel.AimPart.CFrame:ToObjectSpace(_G.framework.viewmodel.PrimaryPart.CFrame)
		aimCF = aimCF:Lerp(offset, _G.framework.module.aimSmooth)
		currentSwayAMT = aimSwayAMT
	else
		local offset = CFrame.new()
		aimCF = aimCF:Lerp(offset, 0.25)
		currentSwayAMT = swayAMT
	end
end)

UserInputService.InputBegan:Connect(function(input)	
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		isAiming = true
		UserInputService.MouseIconEnabled = false
	end
	
	local glockReloadSound = Instance.new("Sound")
	glockReloadSound.SoundId = "rbxassetid://801221137"
	glockReloadSound.Looped = false
	glockReloadSound.Parent = player
	
	local m4ReloadSound = Instance.new("Sound")
	m4ReloadSound.SoundId = "rbxassetid://8392444626"
	m4ReloadSound.Looped = false
	m4ReloadSound.Parent = player
	
	if input.KeyCode == Enum.KeyCode.One then
		if _G.framework.currentSlot == 2 then
			check = false
			equipped = false
		end

		if check == true then
			equipped = false
			check = false
		end
		_G.loadSlot (_G.framework.inventory[1])
		_G.framework.currentSlot = 1
		if check == false then
			equipped = true
		end
	end
	
	if input.KeyCode == Enum.KeyCode.Two then
		if _G.framework.currentSlot == 1 then
			check = false
			equipped = false
		end

		if check == true then
			equipped = false
			check = false
		end
		_G.loadSlot (_G.framework.inventory[2])
		_G.framework.currentSlot = 2
		if check == false then
			equipped = true
		end
	end
	
	if input.KeyCode == Enum.KeyCode.R and _G.glockAmmo.Value < 17 and _G.framework.currentSlot == 1 then
		reloadAnim:Play()
		glockReloadSound:Play()
		wait(1.5)
		_G.glockAmmo.Value = 17
	end
	
	if _G.glockAmmo.Value == 0 and _G.framework.currentSlot == 1 and wasEmpty == false then
		glockEmptyAnim:Play()
		glockEmptyIdleAnim:Play()		
		wasEmpty = true
	end
	
	if _G.glockAmmo.Value > 0 and _G.framework.currentSlot == 1 and glockEmptyAnim then
		glockEmptyIdleAnim:Stop()
		wasEmpty = false
	end
	
	if input.KeyCode == Enum.KeyCode.R and _G.m4Ammo.Value < 30 and _G.framework.currentSlot == 2 then
		reloadAnim:Play()
		m4ReloadSound:Play()
		wait(1.5)
		_G.m4Ammo.Value = 30
	end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 and _G.glockAmmo.Value > 0 and _G.framework.currentSlot == 1 and fireAnim and muzzleFlash.ParticleEmitter then
		fireAnim:Play()
		muzzleFlash.ParticleEmitter:Emit(1)
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 and _G.m4Ammo.Value > 0 and _G.framework.currentSlot == 2  and _G.fullAuto == false and muzzleFlash.ParticleEmitter then
		fireAnim:Play()
		muzzleFlash.ParticleEmitter:Emit(1)
	end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 and _G.m4Ammo.Value > 0 and _G.framework.currentSlot == 2  and _G.fullAuto and muzzleFlash.ParticleEmitter then
		fullAutoAnim:Play()
		muzzleFlash.ParticleEmitter.Rate = 20
	end

end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		isAiming = false
		UserInputService.MouseIconEnabled = true
	end
	
	if _G.fullAuto then
		fullAutoAnim:Stop()
		muzzleFlash.ParticleEmitter.Rate = 0
	end
end)

humanoid.Died:Connect(function()
	for i,v in pairs(camera:GetChildren()) do
		if v:IsA("Model") then
			v:Destroy()
		end
	end
	equipped = false
	check = false
end)

-- Mobile Reload and Aim Buttons

local ContextActionService = game:GetService("ContextActionService")

local function reload()
	local glockReloadSound = Instance.new("Sound")
	glockReloadSound.SoundId = "rbxassetid://801221137"
	glockReloadSound.Looped = false
	glockReloadSound.Parent = player

	local m4ReloadSound = Instance.new("Sound")
	m4ReloadSound.SoundId = "rbxassetid://8392444626"
	m4ReloadSound.Looped = false
	m4ReloadSound.Parent = player
	
	if _G.glockAmmo.Value < 17 and _G.framework.currentSlot == 1 then
		reloadAnim:Play()
		glockReloadSound:Play()
		wait(1.5)
		_G.glockAmmo.Value = 17
	end
	if _G.m4Ammo.Value < 30 and _G.framework.currentSlot == 2 then
		reloadAnim:Play()
		m4ReloadSound:Play()
		wait(1.5)
		_G.m4Ammo.Value = 30
	end
end

local function aim(_, inputState)
	if inputState ~= Enum.UserInputState.End then
		return
	end
	if isAiming == false then
		isAiming = true
		mouse.Icon = "http://www.roblox.com/asset/?id=11232270732"
	else 
		isAiming = false
		mouse.Icon = "http://www.roblox.com/asset/?id=417446600"	
	end
end

local function fire(_, inputState)
	local fireSound = Instance.new("Sound")
	fireSound.SoundId = "rbxassetid://801217802"
	fireSound.Looped = false
	fireSound.Parent = player

	local emptySound = Instance.new("Sound")
	emptySound.SoundId = "rbxassetid://132464034"
	emptySound.Looped = false
	emptySound.Parent = player
	
	if inputState ~= Enum.UserInputState.End then
		return
	end
	if _G.glockAmmo.Value > 0 and _G.framework.currentSlot == 1 and fireAnim then
		fireSound:Play()
		fireAnim:Play()
		muzzleFlash.ParticleEmitter:Emit(1)
		_G.glockAmmo.Value -= 1
	end
	if _G.m4Ammo.Value > 0 and _G.framework.currentSlot == 2 and fireAnim then
		fireSound:Play()
		fireAnim:Play()
		muzzleFlash.ParticleEmitter:Emit(1)
		_G.m4Ammo.Value -= 1
	end
end

ContextActionService:BindAction("Reload", reload, true)
ContextActionService:SetPosition("Reload", UDim2.new(1, -70, 0, 10))
ContextActionService:SetImage("Reload", "rbxassetid://6943199776")

ContextActionService:BindAction("Aim", aim, true)
ContextActionService:SetPosition("Aim", UDim2.new(1, -70, 0, -60))
ContextActionService:SetImage("Aim", "rbxassetid://7171043303")

-- Use Button To Fire -- Would need to Disable Tool Raycast from Mobile and change it to middle of Camera
--ContextActionService:BindAction("Fire", fire, true)
--ContextActionService:SetPosition("Fire", UDim2.new(1, -120, 0, 10))
--ContextActionService:SetImage("Fire", "rbxassetid://9126971632")