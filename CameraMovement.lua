local userInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local camera = game.Workspace.Camera

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

RunService.RenderStepped:Connect(function()
	if humanoid then
		if humanoid.MoveDirection.Magnitude > 0 then
			local headBobY = math.sin(tick() * 10) * 0.2
			
			if humanoid.WalkSpeed < 25 then
				headBobY = math.sin(tick() * 10) * 0.3
			else
				headBobY = math.sin(tick() * 15) * 0.4
			end
			
			local bob = Vector3.new(0, headBobY, 0)
			
			humanoid.CameraOffset = humanoid.CameraOffset:Lerp(bob, 0.1)
			
		else
			humanoid.CameraOffset = humanoid.CameraOffset:Lerp(Vector3.new(), 0.1)
		end
	end
end)

humanoid.Died:Connect(function()
	print("died")
	for i,v in pairs(camera:GetChildren()) do
		if v:IsA("Model") then
			v:Destroy()
		end
	end
end)