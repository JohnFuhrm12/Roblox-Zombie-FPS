local Player = game.Players.LocalPlayer
local Character = Player.CharacterAdded:Wait()

local Tool = script.Parent
local Animation = Instance.new("Animation")
Animation.Parent = Tool

local Humanoid = Character:WaitForChild("Humanoid")

local moduleFolder = game.ReplicatedStorage.Modules
glockModule = require(moduleFolder:FindFirstChild("Glock"))

local AnimationIds = {
	glockModule.toolEquipAnim;
	glockModule.toolIdleAnim;
	"http://www.roblox.com/asset/?id=11479614786",
	"http://www.roblox.com/asset/?id=11480013307"
}

local Tracks = {}

for Index, AnimationId in pairs(AnimationIds) do 
	Animation.AnimationId = AnimationId
	Tracks[Index] = Humanoid:LoadAnimation(Animation)
	local CurrentTrack = Tracks[Index]
	CurrentTrack.Priority = Enum.AnimationPriority.Action 
end

local function OnEquipped() 
	Tracks[1]:Play()
	Tracks[2]:Play()
end

local function OnUnequipped() 
	for _, Track in pairs(Tracks) do
		if Track.IsPlaying then
			Track:Stop()
		end
	end
end

Tool.Equipped:Connect(OnEquipped)
Tool.Unequipped:Connect(OnUnequipped)