repeat wait() until game.Players.LocalPlayer

m = game.Players.LocalPlayer:GetMouse()

m.KeyDown:connect(function(key)
	if key == "0" then --"Shift to run" 0 == shift
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 25
	end
end)

m.KeyUp:connect(function(key)
	if key == "0" then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 
	end
end)
