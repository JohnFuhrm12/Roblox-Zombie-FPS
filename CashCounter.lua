local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tycoonName = game.Workspace.Tycoons["Rocky Outpost"]
local tycoonClaim = tycoonName.ClaimDoor:WaitForChild("Part")

local player = game.Players.LocalPlayer

tycoonClaim.Touched:Connect(function()
	print("Touched")
	if player.Team.Name == "Unclaimed" then
		local tycoon = tycoonName
		local cashAmount = tycoon:FindFirstChild("Cash")
		local cashValue = cashAmount.Value
		cashAmount.Changed:Connect(function()
			local pg = PlayerService.LocalPlayer.PlayerGui
			local cash = pg.CashGUI.CashFrame.CashAmount

			local newVal = cashAmount.Value
			cash.Text = cashAmount.Value
		end)
	end
end)