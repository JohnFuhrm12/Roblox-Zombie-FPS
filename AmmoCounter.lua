local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = game:GetService('Players').LocalPlayer
_G.glockAmmo = plr.Backpack.Glock.GlockAmmo

local pg = PlayerService.LocalPlayer.PlayerGui
local glockAmmoGUI = pg.GlockGui.AmmoFrame.MagCount

_G.glockAmmo.Changed:Connect(function()
	local newVal = _G.glockAmmo.Value
	glockAmmoGUI.Text = _G.glockAmmo.Value
end)

